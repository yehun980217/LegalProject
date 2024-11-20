package com.kpaas.kpaasproject.service;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.kpaas.kpaasproject.dto.UserDTO;
import com.kpaas.kpaasproject.mapper.LogMapper;
import com.kpaas.kpaasproject.mapper.UserMapper;
import lombok.ToString;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

@Service
@ToString
public class LogServiceImpl implements LogService {

    @Autowired
    LogMapper logMapper;

    @Autowired
    UserMapper userMapper;

    @Override
    public String getUserPwdById(String userId) {

        return logMapper.findUserPwd(userId) ;
    }

    @Override
    public UserDTO getUserById(String userId) {
        return logMapper.getUserInfoById(userId);
    }

    @Override
    public String getAccessToken(String code) {
        String access_Token = "";
        String refresh_Token = "";
        String reqURL = "https://kauth.kakao.com/oauth/token";

        try {
            // url 객체 생성
            URL url = new URL(reqURL);

            // url에서 url connection 객체 얻기
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            // setRequestMethod : HTTP 메소드 설정, 기본값은 GET
            conn.setRequestMethod("POST");
            // setDoOutput : urlconnection이 서버에 데이터를 보낼 수 있는지 여부 설정, 기본값 false
            conn.setDoOutput(true);

            // POST 요청에 필요로 요구하는 파라미터 스트림을 통해 전송
            // POST로 보낼 Body 작성
            BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));

            StringBuilder sb = new StringBuilder();
            sb.append("grant_type=authorization_code");
            sb.append("&client_id=fa1db4eed4a7af6be4d2ffab7b44eb87");
            sb.append("&redirect_uri=http://localhost:11100/login/kakao_login"); // 본인이 설정한 주소
            sb.append("&code=" + code);

            // 버퍼에 있는 값 전부 출력
            bw.write(sb.toString());

            // 남아있는 데이터를 모두 출력
            bw.flush();

            // 결과 코드가 200이라면 성공
            int responseCode = conn.getResponseCode();
            System.out.println("responseCode : " + responseCode);

            // 요청을 통해 얻은 JSON 타입의 Response 메세지 읽어오기
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String line = "";
            String result = "";

            while ((line = br.readLine()) != null) {
                result += line;
            }
            System.out.println("response body : " + result);

            // Gson 라이브러리에 포함된 클래스로 JSON파싱 객체 생성
            JsonParser parser = new JsonParser();
            JsonElement element = parser.parse(result);

            access_Token = element.getAsJsonObject().get("access_token").getAsString();
            refresh_Token = element.getAsJsonObject().get("refresh_token").getAsString();

            System.out.println("access_token : " + access_Token);
            System.out.println("refresh_token : " + refresh_Token);

            br.close();
            bw.close();

        } catch (IOException e) {
            e.printStackTrace();
        }

        return access_Token;
    }

    // 카카오 회원 정보 받기
    @Override
    public UserDTO getUserInfo(String access_Token) {

        // 요청하는 클라이언트마다 가진 정보가 다를 수 있기에 HashMap타입으로 선언
        HashMap<String, Object> userInfo = new HashMap<String, Object>();
        String reqURL = "https://kapi.kakao.com/v2/user/me";

        try {
            URL url = new URL(reqURL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + access_Token);

            int responseCode = conn.getResponseCode();
            System.out.println("responseCode : " + responseCode);
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String line = "";
            String result = "";

            while ((line = br.readLine()) != null) {
                result += line;
            }
            System.out.println("response body : " + result);

            JsonParser parser = new JsonParser();
            JsonElement element = parser.parse(result);
            JsonObject properties = element.getAsJsonObject().get("properties").getAsJsonObject();
            JsonObject kakao_account = element.getAsJsonObject().get("kakao_account").getAsJsonObject();
            String nickname = properties.getAsJsonObject().get("nickname").getAsString();
            String email = kakao_account.getAsJsonObject().get("email").getAsString();

            // email에서 @의 앞부분을 id로 설정
            String[] id = email.split("@");

            userInfo.put("userId", id[0]);
            userInfo.put("userName", nickname);
//            userInfo.put("email", email);


        } catch (IOException e) {
            e.printStackTrace();
        }
        // 회원 정보가 있는지 확인
        UserDTO result = logMapper.findKakao(userInfo);

        // 회원 정보 없을 때
        if(result == null) {
            logMapper.kakaoInsert(userInfo);
            return logMapper.findKakao(userInfo);
        } else {
            return result; // 회원 정보 있으면 회원 정보 리턴
        }
    }

    @Override
    public String findUserIdByNameAndPhone(String userName, String userPhoneNum) {
        return logMapper.findUserByNameAndPhone(userName, userPhoneNum);
    }

    @Override
    public UserDTO findUserByIdNamePhone(String userId, String userName, String userPhoneNum) {
        return logMapper.findUserByIdNamePhone(userId, userName, userPhoneNum);
    }

    @Override
    public void updatePassword(String userId, String encryptedPassword) {
        Map<String, String> paramMap = new HashMap<>();
        paramMap.put("userId", userId);
        paramMap.put("userPwd", encryptedPassword); // 암호화된 비밀번호로 업데이트

        // 로그로 확인
        System.out.println("DB에 저장되는 암호화된 비밀번호: " + encryptedPassword);

        logMapper.updatePassword(paramMap);
    }

}
