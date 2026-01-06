package com.sky.vo;

import lombok.Data;
import java.util.List;

@Data
public class ChatHistoryVO {
    private List<ChatMessageVO> messages;

    public ChatHistoryVO() {}

    public ChatHistoryVO(List<ChatMessageVO> messages) {
        this.messages = messages;
    }
}
