package com.sky.tools;

import com.sky.entity.Category;
import com.sky.entity.Dish;
import com.sky.entity.Employee;
import com.sky.entity.Orders;
import com.sky.mapper.CategoryMapper;
import com.sky.mapper.DishMapper;
import com.sky.mapper.EmployeeMapper;
import com.sky.mapper.OrderMapper;
import dev.langchain4j.agent.tool.P;
import dev.langchain4j.agent.tool.Tool;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Component
public class AssistantTools {

    @Autowired
    private EmployeeMapper employeeMapper;

    @Autowired
    private DishMapper dishMapper;

    @Autowired
    private CategoryMapper categoryMapper;

    @Autowired
    private OrderMapper orderMapper;

    // ==================== 员工相关Tool ====================

    @Tool(name = "获取所有员工信息", value = "获取系统已经注册的所有员工信息")
    public String getEmployee() {
        List<Employee> employees = employeeMapper.getAll();

        StringBuilder sb = new StringBuilder();
        sb.append("以下是系统中的员工信息概览：\n\n");
        sb.append("| ID | 姓名 | 用户名 | 手机号 | 状态 |\n");
        sb.append("|----|------|--------|--------|------|\n");

        for (Employee e : employees) {
            String statusText = "未知";
            if (e.getStatus() != null) {
                statusText = e.getStatus() == 1 ? "启用" : "禁用";
            }
            sb.append("| ")
                    .append(e.getId()).append(" | ")
                    .append(e.getName()).append(" | ")
                    .append(e.getUsername()).append(" | ")
                    .append(e.getPhone()).append(" | ")
                    .append(statusText).append(" |\n");
        }

        sb.append("\n**提示**：如果需要查看某个员工的详细信息，请提供员工的 **ID**。");
        return sb.toString();
    }

    @Tool(name = "根据id获取员工信息", value = "根据员工id获取员工详细信息")
    public String getEmployeeById(@P(value = "员工ID", required = true) Long id) {
        Employee employee = employeeMapper.getById(id);
        if (employee == null) {
            return "❌ 员工不存在，ID：" + id;
        }

        String statusText = employee.getStatus() == 1 ? "启用" : "禁用";
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

        StringBuilder sb = new StringBuilder();
        sb.append("📋 员工详细信息：\n\n");
        sb.append("- **ID**: ").append(employee.getId()).append("\n");
        sb.append("- **姓名**: ").append(employee.getName()).append("\n");
        sb.append("- **用户名**: ").append(employee.getUsername()).append("\n");
        sb.append("- **手机号**: ").append(employee.getPhone()).append("\n");
        sb.append("- **状态**: ").append(statusText).append("\n");
        if (employee.getCreateTime() != null) {
            sb.append("- **创建时间**: ").append(employee.getCreateTime().format(dtf)).append("\n");
        }

        return sb.toString();
    }

    // ==================== 菜品相关Tool ====================

    @Tool(name = "查询所有菜品", value = "查询系统中的所有菜品列表")
    public String getAllDishes() {
        List<Dish> dishes = dishMapper.getAll();

        if (dishes == null || dishes.isEmpty()) {
            return "📭 系统中暂无菜品";
        }

        StringBuilder sb = new StringBuilder();
        sb.append("🍽️ 以下是系统中的菜品列表：\n\n");
        sb.append("| ID | 名称 | 价格 | 分类ID | 状态 |\n");
        sb.append("|----|------|------|--------|------|\n");

        for (Dish d : dishes) {
            String statusText = (d.getStatus() != null && d.getStatus() == 1) ? "在售" : "停售";
            sb.append("| ")
                    .append(d.getId()).append(" | ")
                    .append(d.getName()).append(" | ")
                    .append("¥").append(d.getPrice()).append(" | ")
                    .append(d.getCategoryId()).append(" | ")
                    .append(statusText).append(" |\n");
        }

        sb.append("\n共 **").append(dishes.size()).append("** 个菜品");
        return sb.toString();
    }

    @Tool(name = "根据ID查询菜品", value = "根据菜品ID查询菜品详细信息")
    public String getDishById(@P(value = "菜品ID", required = true) Long id) {
        Dish dish = dishMapper.getById(id);
        if (dish == null) {
            return "❌ 菜品不存在，ID：" + id;
        }

        String statusText = (dish.getStatus() != null && dish.getStatus() == 1) ? "在售" : "停售";

        StringBuilder sb = new StringBuilder();
        sb.append("🍽️ 菜品详细信息：\n\n");
        sb.append("- **ID**: ").append(dish.getId()).append("\n");
        sb.append("- **名称**: ").append(dish.getName()).append("\n");
        sb.append("- **价格**: ¥").append(dish.getPrice()).append("\n");
        sb.append("- **分类ID**: ").append(dish.getCategoryId()).append("\n");
        sb.append("- **描述**: ").append(dish.getDescription() != null ? dish.getDescription() : "无").append("\n");
        sb.append("- **状态**: ").append(statusText).append("\n");

        return sb.toString();
    }

    @Tool(name = "添加菜品", value = "向系统中添加新菜品")
    public String addDish(
            @P(value = "菜品名称", required = true) String name,
            @P(value = "菜品价格", required = true) BigDecimal price,
            @P(value = "分类ID", required = true) Long categoryId,
            @P(value = "菜品描述") String description) {

        // 检查分类是否存在
        Category category = categoryMapper.getById(categoryId);
        if (category == null) {
            return "❌ 添加失败：分类ID " + categoryId + " 不存在，请先查询分类列表";
        }

        Dish dish = new Dish();
        dish.setName(name);
        dish.setPrice(price);
        dish.setCategoryId(categoryId);
        dish.setDescription(description);
        dish.setStatus(1); // 默认在售
        dish.setCreateTime(LocalDateTime.now());
        dish.setUpdateTime(LocalDateTime.now());

        dishMapper.insert(dish);

        return "✅ 菜品添加成功！\n\n" +
                "- **名称**: " + name + "\n" +
                "- **价格**: ¥" + price + "\n" +
                "- **分类**: " + category.getName() + "\n" +
                "- **状态**: 在售";
    }

    @Tool(name = "修改菜品价格", value = "修改指定菜品的价格")
    public String updateDishPrice(
            @P(value = "菜品ID", required = true) Long dishId,
            @P(value = "新价格", required = true) BigDecimal newPrice) {

        Dish dish = dishMapper.getById(dishId);
        if (dish == null) {
            return "❌ 修改失败：菜品ID " + dishId + " 不存在";
        }

        BigDecimal oldPrice = dish.getPrice();
        dish.setPrice(newPrice);
        dish.setUpdateTime(LocalDateTime.now());
        dishMapper.update(dish);

        return "✅ 价格修改成功！\n\n" +
                "- **菜品**: " + dish.getName() + "\n" +
                "- **原价**: ¥" + oldPrice + "\n" +
                "- **新价**: ¥" + newPrice;
    }

    @Tool(name = "删除菜品", value = "删除指定的菜品")
    public String deleteDish(@P(value = "菜品ID", required = true) Long dishId) {

        Dish dish = dishMapper.getById(dishId);
        if (dish == null) {
            return "❌ 删除失败：菜品ID " + dishId + " 不存在";
        }

        String dishName = dish.getName();
        dishMapper.deleteById(dishId);

        return "✅ 菜品「" + dishName + "」已成功删除";
    }

    @Tool(name = "修改菜品状态", value = "启用或停用菜品，status为1表示启用，0表示停用")
    public String updateDishStatus(
            @P(value = "菜品ID", required = true) Long dishId,
            @P(value = "状态：1启用，0停用", required = true) Integer status) {

        Dish dish = dishMapper.getById(dishId);
        if (dish == null) {
            return "❌ 操作失败：菜品ID " + dishId + " 不存在";
        }

        dish.setStatus(status);
        dish.setUpdateTime(LocalDateTime.now());
        dishMapper.update(dish);

        String statusText = status == 1 ? "启用（在售）" : "停用（停售）";
        return "✅ 菜品「" + dish.getName() + "」状态已修改为：" + statusText;
    }

    // ==================== 分类相关Tool ====================

    @Tool(name = "查询分类列表", value = "查询所有菜品分类")
    public String getAllCategories() {
        List<Category> categories = categoryMapper.getAll();

        if (categories == null || categories.isEmpty()) {
            return "📭 系统中暂无分类";
        }

        StringBuilder sb = new StringBuilder();
        sb.append("📂 以下是菜品分类列表：\n\n");
        sb.append("| ID | 分类名称 | 类型 | 状态 |\n");
        sb.append("|----|----------|------|------|\n");

        for (Category c : categories) {
            String typeText = (c.getType() != null && c.getType() == 1) ? "菜品" : "套餐";
            String statusText = (c.getStatus() != null && c.getStatus() == 1) ? "启用" : "禁用";
            sb.append("| ")
                    .append(c.getId()).append(" | ")
                    .append(c.getName()).append(" | ")
                    .append(typeText).append(" | ")
                    .append(statusText).append(" |\n");
        }

        sb.append("\n💡 添加菜品时需要使用分类ID");
        return sb.toString();
    }

    // ==================== 订单相关Tool ====================

    @Tool(name = "查询今日订单", value = "查询今天的所有订单")
    public String getTodayOrders() {
        LocalDateTime beginTime = LocalDateTime.of(LocalDate.now(), LocalTime.MIN);
        LocalDateTime endTime = LocalDateTime.of(LocalDate.now(), LocalTime.MAX);

        List<Orders> orders = orderMapper.getByTime(beginTime, endTime);

        if (orders == null || orders.isEmpty()) {
            return "📭 今日暂无订单";
        }

        StringBuilder sb = new StringBuilder();
        sb.append("📋 今日订单列表：\n\n");
        sb.append("| 订单号 | 金额 | 状态 | 下单时间 |\n");
        sb.append("|--------|------|------|----------|\n");

        BigDecimal totalAmount = BigDecimal.ZERO;
        for (Orders o : orders) {
            String statusText = getOrderStatusText(o.getStatus());
            String time = o.getOrderTime() != null ?
                    o.getOrderTime().format(DateTimeFormatter.ofPattern("HH:mm")) : "-";
            sb.append("| ")
                    .append(o.getNumber()).append(" | ")
                    .append("¥").append(o.getAmount()).append(" | ")
                    .append(statusText).append(" | ")
                    .append(time).append(" |\n");
            if (o.getAmount() != null) {
                totalAmount = totalAmount.add(o.getAmount());
            }
        }

        sb.append("\n📊 **统计**：共 ").append(orders.size()).append(" 单，总金额 ¥").append(totalAmount);
        return sb.toString();
    }

    @Tool(name = "查询订单详情", value = "根据订单ID查询订单详细信息")
    public String getOrderById(@P(value = "订单ID", required = true) Long orderId) {
        Orders order = orderMapper.getById(orderId);
        if (order == null) {
            return "❌ 订单不存在，ID：" + orderId;
        }

        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String statusText = getOrderStatusText(order.getStatus());

        StringBuilder sb = new StringBuilder();
        sb.append("📋 订单详细信息：\n\n");
        sb.append("- **订单ID**: ").append(order.getId()).append("\n");
        sb.append("- **订单号**: ").append(order.getNumber()).append("\n");
        sb.append("- **状态**: ").append(statusText).append("\n");
        sb.append("- **金额**: ¥").append(order.getAmount()).append("\n");
        sb.append("- **收货人**: ").append(order.getConsignee()).append("\n");
        sb.append("- **电话**: ").append(order.getPhone()).append("\n");
        sb.append("- **地址**: ").append(order.getAddress()).append("\n");
        if (order.getOrderTime() != null) {
            sb.append("- **下单时间**: ").append(order.getOrderTime().format(dtf)).append("\n");
        }

        return sb.toString();
    }

    @Tool(name = "查询订单统计", value = "查询指定日期的订单统计，包括订单数和营业额")
    public String getOrderStatistics(
            @P(value = "日期，格式yyyy-MM-dd，不填则为今天") String dateStr) {

        LocalDate date;
        if (dateStr == null || dateStr.isEmpty()) {
            date = LocalDate.now();
        } else {
            date = LocalDate.parse(dateStr);
        }

        LocalDateTime beginTime = LocalDateTime.of(date, LocalTime.MIN);
        LocalDateTime endTime = LocalDateTime.of(date, LocalTime.MAX);

        List<Orders> orders = orderMapper.getByTime(beginTime, endTime);

        int totalCount = orders != null ? orders.size() : 0;
        int completedCount = 0;
        BigDecimal totalAmount = BigDecimal.ZERO;

        if (orders != null) {
            for (Orders o : orders) {
                if (o.getStatus() != null && o.getStatus() == 5) { // 已完成
                    completedCount++;
                    if (o.getAmount() != null) {
                        totalAmount = totalAmount.add(o.getAmount());
                    }
                }
            }
        }

        StringBuilder sb = new StringBuilder();
        sb.append("📊 **").append(date).append(" 订单统计**\n\n");
        sb.append("- **总订单数**: ").append(totalCount).append(" 单\n");
        sb.append("- **已完成**: ").append(completedCount).append(" 单\n");
        sb.append("- **营业额**: ¥").append(totalAmount).append("\n");

        return sb.toString();
    }

    // ==================== 辅助方法 ====================

    private String getOrderStatusText(Integer status) {
        if (status == null) return "未知";
        switch (status) {
            case 1: return "待付款";
            case 2: return "待接单";
            case 3: return "已接单";
            case 4: return "派送中";
            case 5: return "已完成";
            case 6: return "已取消";
            default: return "未知";
        }
    }
}