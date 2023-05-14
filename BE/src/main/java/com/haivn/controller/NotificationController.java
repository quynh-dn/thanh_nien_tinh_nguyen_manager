package com.haivn.controller;

import com.haivn.handler.NotificationHandler;
import com.google.zxing.WriterException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import javax.validation.Valid;
import java.io.IOException;

@RequestMapping("/api/broadcast")
@RestController
@Slf4j
public class NotificationController extends TextWebSocketHandler {
    public NotificationController(){

    }

    @PostMapping("/all")
    @ResponseStatus(value = HttpStatus.OK)
    public ResponseEntity<Boolean> sendMessageHandler(@Valid @RequestBody(required = true) final String content) throws IOException, WriterException {
        TextMessage msgSocket = new TextMessage(content);
        NotificationHandler noti = new NotificationHandler();
        noti.handleTextMessage(null, msgSocket);

        return ResponseEntity.ok(true);
    }


}
