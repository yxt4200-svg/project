package com.sky.handler;

import com.sky.constant.MessageConstant;
import com.sky.exception.BaseException;
import com.sky.result.Result;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.Objects;

/**
 * 全局异常处理器，处理项目中抛出的所有异常，确保响应均为JSON格式
 */
@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    /**
     * 1. 处理业务异常（如登录失败、地址为空、购物车为空等，自定义的BaseException子类）
     * 明确指定拦截BaseException及其子类，避免歧义
     */
    @ExceptionHandler(BaseException.class) // 优化1：指定异常类型
    public Result<Void> handleBaseException(BaseException ex, HttpServletResponse response) {
        log.error("业务异常：{}", ex.getMessage());
        // 强制返回200状态码，避免前端因4xx/5xx状态码拒绝解析JSON
        response.setStatus(HttpServletResponse.SC_OK);
        // 返回Result<Void>，更贴合“仅提示信息，无业务数据”的场景
        return Result.error(ex.getMessage());
    }

    /**
     * 2. 处理数据库唯一约束异常（如用户名重复、手机号重复）
     */
    @ExceptionHandler(SQLIntegrityConstraintViolationException.class) // 优化2：明确异常类型
    public Result<Void> handleSQLConstraintException(SQLIntegrityConstraintViolationException ex, HttpServletResponse response) {
        log.error("数据库约束异常：{}", ex.getMessage());
        response.setStatus(HttpServletResponse.SC_OK);

        String errorMsg = ex.getMessage();
        if (Objects.nonNull(errorMsg) && errorMsg.contains("Duplicate entry")) {
            // 解析异常信息，提取重复的字段值（如“Duplicate entry 'zhangsan' for key...”）
            String[] errorParts = errorMsg.split(" ");
            String duplicateValue = errorParts.length > 2 ? errorParts[2] : "未知字段";
            return Result.error(duplicateValue + MessageConstant.ACCOUNT_ALREADY_EXIST);
        }
        // 其他数据库约束异常（如外键关联）
        return Result.error(MessageConstant.DATABASE_CONSTRAINT_ERROR);
    }

    /**
     * 3. 处理通用异常（如空指针、参数非法等，兜底处理，避免返回非JSON响应）
     * 优化3：新增通用异常拦截，覆盖所有未明确处理的异常
     */
    @ExceptionHandler(Exception.class)
    public Result<Void> handleGeneralException(Exception ex, HttpServletResponse response) {
        log.error("系统通用异常：", ex); // 打印完整堆栈，便于排查问题
        response.setStatus(HttpServletResponse.SC_OK);
        // 对外隐藏具体异常信息，返回通用提示
        return Result.error(MessageConstant.UNKNOWN_ERROR);
    }
}