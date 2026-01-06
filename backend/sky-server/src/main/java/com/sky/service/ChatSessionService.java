package com.sky.service;

import com.sky.dto.ChatMessageDTO;
import com.sky.vo.ChatHistoryVO;
import com.sky.vo.ChatSessionCreateVO;
import com.sky.vo.ChatSessionVO;
import reactor.core.publisher.Flux;

import java.util.List;

public interface ChatSessionService {

    List<ChatSessionVO> getChatSessions(Long adminId);

    ChatSessionCreateVO createNewSession();

    Flux<String> sendMessage(ChatMessageDTO chatMessageDTO);

    ChatHistoryVO getChatHistory(Long memoryId);

    void deleteSession(Long sessionId);

    void updateSessionTitle(Long memoryId, String lastMessage);
}