package com.sky.controller.admin;

import com.sky.assistant.Assistant;
import com.sky.bean.ChatForm;
import com.sky.context.BaseContext;
import com.sky.result.Result;
import com.sky.service.ChatSessionService;
import com.sky.vo.ChatHistoryVO;
import com.sky.vo.ChatSessionCreateVO;
import com.sky.vo.ChatSessionVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/admin/chat")
@Slf4j
@Tag(name = "聊天助手接口")
public class AssistantController {

    @Autowired
    private Assistant assistant;

    @Autowired
    private ChatSessionService chatService;

    @Operation(summary = "新建对话")
    @PostMapping("/sessions")
    public Result<ChatSessionCreateVO> createSession() {
        log.info("创建对话");
        ChatSessionCreateVO newSession = chatService.createNewSession();
        return Result.success(newSession);
    }

    @GetMapping("/sessions")
    @Operation(summary = "获取会话列表")
    public Result<List<ChatSessionVO>> getSessionList() {
        log.info("获取会话列表");
        Long adminId = BaseContext.getCurrentId();
        List<ChatSessionVO> sessionList = chatService.getChatSessions(adminId);
        return Result.success(sessionList);
    }

    @GetMapping("/history/{memoryId}")
    @Operation(summary = "获取聊天历史")
    public Result<ChatHistoryVO> getChatHistory(@PathVariable Long memoryId) {
        ChatHistoryVO history = chatService.getChatHistory(memoryId);
        return Result.success(history);
    }

    @DeleteMapping("/sessions/{sessionId}")
    @Operation(summary = "删除会话")
    public Result<String> deleteSession(@PathVariable Long sessionId) {
        log.info("删除会话，sessionId: {}", sessionId);
        chatService.deleteSession(sessionId);
        return Result.success("删除成功");
    }

    @Operation(summary = "聊天")
    @PostMapping(value = "/assistant")
    public Result<String> chat(@RequestBody ChatForm chatForm) {
        Long adminId = BaseContext.getCurrentId();
        String userMessage = chatForm.getMessage();
        String promptWithMessage = String.format("当前操作的管理员ID是 %d。用户的请求是：%s", adminId, userMessage);

        log.info("向大模型发送的带上下文的提示: {}", promptWithMessage);

        String response = assistant.chat(chatForm.getMemoryId(), promptWithMessage);
        chatService.updateSessionTitle(chatForm.getMemoryId(), response);

        return Result.success(response);
    }
}
