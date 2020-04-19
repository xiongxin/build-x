package com.xiongxin.app.json;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.databind.util.StdConverter;
import lombok.Data;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.FormatStyle;
import java.util.Locale;

public class JsonSerializeDeserializeConverter {

  @Data
  private static class CurrencyRate {
    private String pair;
    private double rate;

    @JsonSerialize(converter = LocalDateTimeToStringConverter.class)
    @JsonDeserialize(converter = StringToLocalDatetimeConverter.class)
    private LocalDateTime lastUpdated;
  }

  private static class LocalDateTimeToStringConverter extends StdConverter<LocalDateTime, String> {

    static final DateTimeFormatter DATE_TIME_FORMATTER =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss", Locale.CHINA);

    @Override
    public String convert(LocalDateTime localDateTime) {
      System.out.println(localDateTime.format(DATE_TIME_FORMATTER));
      return localDateTime.format(DATE_TIME_FORMATTER);
    }
  }

  private static class StringToLocalDatetimeConverter extends StdConverter<String, LocalDateTime> {

    @Override
    public LocalDateTime convert(String s) {
      return LocalDateTime.parse(s, LocalDateTimeToStringConverter.DATE_TIME_FORMATTER);
    }
  }


  public static void main(String[] args) throws JsonProcessingException {
    System.out.println("-- Java Object to JSON --");
    CurrencyRate currencyRate = new CurrencyRate();
    currencyRate.setPair("USD/JPY");
    currencyRate.setRate(109.15);
    currencyRate.setLastUpdated(LocalDateTime.now());
    System.out.println("Java Object: " + currencyRate);
    ObjectMapper objectMapper = new ObjectMapper();
    String str = objectMapper.writeValueAsString(currencyRate);
    System.out.println("JSON string: " + str);

    System.out.println("-- JSON to Java object --");
    CurrencyRate currencyRate1 = objectMapper.readValue(str, CurrencyRate.class);
    System.out.println("Java object: " + currencyRate1);
  }
}
