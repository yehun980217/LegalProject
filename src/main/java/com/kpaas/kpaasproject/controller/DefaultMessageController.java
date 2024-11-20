package com.kpaas.kpaasproject.controller;

import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.request.SingleMessageSendingRequest;
import net.nurigo.sdk.message.response.SingleMessageSentResponse;
import net.nurigo.sdk.message.service.DefaultMessageService;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

@RestController
public class DefaultMessageController {
    final DefaultMessageService messageService;
    // Map to store phone numbers and verification codes
    private Map<String, String> verificationCodes = new HashMap<>();

    public DefaultMessageController() {
        this.messageService = NurigoApp.INSTANCE.initialize("NCS3N3EIVDII6YXO", "1F9JDUMG2DGPZ8O2AIC4PWZR6H7KFK79", "https://api.coolsms.co.kr");
    }

    @PostMapping("/signUp/sendSMS")
    @ResponseBody
    SingleMessageSentResponse sendSMS(@RequestBody Map<String, String> requestData) {
        String userPhoneNum = requestData.get("userPhoneNum");

        Random rand = new Random();
        String numStr = "";
        for(int i=0; i<6; i++) {
            String ran = Integer.toString(rand.nextInt(10));
            numStr += ran;
        }

        Message message = new Message();
        message.setFrom("01022370241");
        message.setTo(userPhoneNum);
        message.setText("인증번호는["+numStr+"]입니다.");

        SingleMessageSentResponse response = this.messageService.sendOne(new SingleMessageSendingRequest(message));

        verificationCodes.put(userPhoneNum, numStr);

        return response;
    }

    @PostMapping(value = "/signUp/verifyCode", consumes = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    String verifyCode(@RequestBody Map<String, String> requestData) {
        String userPhoneNum = requestData.get("userPhoneNum");
        String verificationCode = requestData.get("verificationCode");

        String savedVerificationCode = verificationCodes.get(userPhoneNum);

        if (savedVerificationCode != null && savedVerificationCode.equals(verificationCode)) {
            return "success";
        } else {
            return "fail";
        }
    }
}
