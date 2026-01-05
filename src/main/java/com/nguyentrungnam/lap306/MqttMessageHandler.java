package com.nguyentrungnam.lap306;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.annotation.ServiceActivator;
import org.springframework.messaging.Message;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

@Service
public class MqttMessageHandler {

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @ServiceActivator(inputChannel = "mqttInputChannel")
    public void handleMessage(Message<?> message) {
        String payload = message.getPayload().toString();
        // Log để bạn debug xem backend đã nhận được data chưa
        System.out.println("MQTT Data received: " + payload);

        // Đẩy dữ liệu này xuống Flutter qua WebSocket
        messagingTemplate.convertAndSend("/topic/sensor", payload);
    }
}