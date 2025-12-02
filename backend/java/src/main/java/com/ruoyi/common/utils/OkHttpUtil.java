package com.ruoyi.common.utils;

import okhttp3.*;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Component
public class OkHttpUtil {

    private final OkHttpClient client = new OkHttpClient();

    /**
     * 发送 GET 请求
     */
    public String doGet(String url, Map<String, String> headers, int timeoutSeconds) throws IOException {
        OkHttpClient timeoutClient = new OkHttpClient.Builder()
                .connectTimeout(timeoutSeconds, TimeUnit.SECONDS)
                .readTimeout(timeoutSeconds, TimeUnit.SECONDS)
                .writeTimeout(timeoutSeconds, TimeUnit.SECONDS)
                .build();

        Request.Builder builder = new Request.Builder().url(url);

        if (headers != null) {
            headers.forEach(builder::addHeader);
        }

        Request request = builder.build();
        try (Response response = timeoutClient.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                throw new IOException("Unexpected code " + response);
            }
            if (response.body() != null) {
                return response.body().string();
            } else {
                return null;
            }
        }
    }

    /**
     * 发送 POST 请求（JSON）
     */
    public String doPostJson(String url, String json, Map<String, String> headers) throws IOException {
        RequestBody body = RequestBody.create(json, MediaType.parse("application/json"));

        Request.Builder builder = new Request.Builder().url(url).post(body);

        if (headers != null) {
            headers.forEach(builder::addHeader);
        }

        Request request = builder.build();
        try (Response response = client.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                throw new IOException("Unexpected code " + response);
            }
            if (response.body() != null) {
                return response.body().string();
            } else {
                return null;
            }
        }
    }
}
