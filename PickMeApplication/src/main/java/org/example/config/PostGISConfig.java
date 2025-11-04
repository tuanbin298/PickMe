package org.example.config;

import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.PrecisionModel;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Configuration class for PostGIS/JTS Geometry
 */
@Configuration
public class PostGISConfig {
    
    /**
     * SRID 4326 corresponds to WGS84 coordinate system
     * This is the standard for GPS coordinates (latitude, longitude)
     */
    public static final int WGS84_SRID = 4326;
    
    /**
     * Create GeometryFactory bean with proper SRID configuration
     */
    @Bean
    public GeometryFactory geometryFactory() {
        return new GeometryFactory(new PrecisionModel(), WGS84_SRID);
    }
}