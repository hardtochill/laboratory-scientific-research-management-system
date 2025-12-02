package com.ruoyi.framework.exception;

public class RadarConnectionException extends RuntimeException {
    public RadarConnectionException(String message) {
        super(message);
    }

    public RadarConnectionException(String message, Throwable cause) {
        super(message, cause);
    }
}
