package com.nguyenhoanganh.doancuoiki;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import java.util.HashMap;
import java.util.Map;

@Service
public class MqttToWebSocketService {

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    public void pushToWebSocket(String topic, String payload) {
        try {
            Map<String, Object> message = new HashMap<>();
            message.put("topic", topic);
            message.put("payload", payload);
            message.put("timestamp", System.currentTimeMillis());
            messagingTemplate.convertAndSend("/topic/sensor", message);
            System.out.println("Đã đẩy MQTT message sang WebSocket - Topic: " + topic + ", Payload: " + payload);
        } catch (Exception e) {
            System.err.println("Lỗi khi đẩy message sang WebSocket: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void pushRawPayload(String topic, String payload) {
        try {
            messagingTemplate.convertAndSend("/topic/sensor", payload);
            System.out.println("Đã đẩy raw payload sang WebSocket - Topic: " + topic);
        } catch (Exception e) {
            System.err.println("Lỗi khi đẩy raw payload sang WebSocket: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

