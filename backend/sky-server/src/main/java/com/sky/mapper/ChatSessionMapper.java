package com.sky.mapper;

import com.sky.entity.ChatSession;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface ChatSessionMapper {

    @Insert("INSERT INTO chat_sessions (admin_id, memory_id, session_title, last_message, create_time, update_time, is_deleted) " +
            "VALUES (#{adminId}, #{memoryId}, #{sessionTitle}, #{lastMessage}, #{createTime}, #{updateTime}, #{isDeleted})")
    void insert(ChatSession chatSession);

    @Select("SELECT * FROM chat_sessions WHERE admin_id = #{adminId} AND is_deleted = 0 ORDER BY update_time DESC")
    List<ChatSession> findByAdminId(Long adminId);

    @Select("SELECT * FROM chat_sessions WHERE id = #{id} AND is_deleted = 0")
    ChatSession findById(Long id);

    @Update("UPDATE chat_sessions SET session_title = #{sessionTitle}, last_message = #{lastMessage}, update_time = NOW() WHERE id = #{id}")
    void update(ChatSession chatSession);

    @Delete("DELETE FROM chat_sessions WHERE id = #{id}")
    void deleteById(Long id);

    @Select("SELECT * FROM chat_sessions WHERE memory_id = #{memoryId} AND is_deleted = 0")
    ChatSession findByMemoryId(Long memoryId);
}
