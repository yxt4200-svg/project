package com.sky.assistant;

import dev.langchain4j.service.MemoryId;
import dev.langchain4j.service.SystemMessage;
import dev.langchain4j.service.UserMessage;

public interface Assistant {
    @SystemMessage(fromResource = "templates/SystemMessage.txt")
    String chat(@MemoryId Long memoryId, @UserMessage String message);
}
