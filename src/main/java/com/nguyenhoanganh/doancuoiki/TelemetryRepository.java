package com.nguyenhoanganh.doancuoiki;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.time.LocalDateTime;
import java.util.List;

public interface TelemetryRepository extends JpaRepository<Telemetry, Long> {
    List<Telemetry> findByDeviceId(Long deviceId);
    
    List<Telemetry> findByDeviceIdOrderByTimestampDesc(Long deviceId);
    
    List<Telemetry> findByDeviceIdAndTimestampBetween(Long deviceId, LocalDateTime start, LocalDateTime end);
    
    @Query("SELECT t FROM Telemetry t WHERE t.deviceId = :deviceId AND t.timestamp >= :startTime ORDER BY t.timestamp DESC")
    List<Telemetry> findRecentByDeviceId(@Param("deviceId") Long deviceId, @Param("startTime") LocalDateTime startTime);
    
    @Query("SELECT t FROM Telemetry t WHERE t.deviceId = :deviceId AND t.temperature >= :minTemp AND t.temperature <= :maxTemp ORDER BY t.timestamp DESC")
    List<Telemetry> findByDeviceIdAndTemperatureRange(@Param("deviceId") Long deviceId, @Param("minTemp") Double minTemp, @Param("maxTemp") Double maxTemp);
    
    @Query("SELECT t FROM Telemetry t WHERE t.deviceId = :deviceId AND t.humidity >= :minHumidity AND t.humidity <= :maxHumidity ORDER BY t.timestamp DESC")
    List<Telemetry> findByDeviceIdAndHumidityRange(@Param("deviceId") Long deviceId, @Param("minHumidity") Double minHumidity, @Param("maxHumidity") Double maxHumidity);
    
    @Query("SELECT t FROM Telemetry t WHERE t.deviceId = :deviceId AND t.power >= :minPower ORDER BY t.timestamp DESC")
    List<Telemetry> findByDeviceIdAndMinPower(@Param("deviceId") Long deviceId, @Param("minPower") Double minPower);
    
    Telemetry findFirstByDeviceIdOrderByTimestampDesc(Long deviceId);
}

