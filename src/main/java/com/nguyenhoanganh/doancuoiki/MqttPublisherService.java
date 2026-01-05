package com.nguyenhoanganh.doancuoiki;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.support.MessageBuilder;
import org.springframework.messaging.MessageChannel;
import org.springframework.stereotype.Service;

@Service
public class MqttPublisherService {
    @Autowired
    private MessageChannel mqttOutboundChannel;

    public void publish(String topic, String payload) {
        System.out.println("📤 Publishing to MQTT - Topic: " + topic + ", Payload: [" + payload + "]");
        System.out.println("📤 Payload length: " + payload.length());
        System.out.println("📤 Payload bytes: " + java.util.Arrays.toString(payload.getBytes()));
        try {
            org.springframework.messaging.Message<String> message = MessageBuilder.withPayload(payload)
                    .setHeader("mqtt_topic", topic)
                    .build();
            System.out.println("📤 Message created, sending to channel...");
            boolean sent = mqttOutboundChannel.send(message);
            System.out.println("📤 Message sent result: " + sent);
            if (sent) {
                System.out.println("✅ Successfully published to " + topic + " with payload: [" + payload + "]");
            } else {
                System.err.println("❌ Failed to send message to MQTT channel");
            }
        } catch (Exception e) {
            System.err.println("❌ Error publishing to MQTT: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
}


