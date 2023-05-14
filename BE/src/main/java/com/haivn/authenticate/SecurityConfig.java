package com.haivn.authenticate;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private JwtRequestFilter jwtRequestFilter;

    @Override
    public void configure(WebSecurity web) {
        web.ignoring().antMatchers("/swagger-ui/**", "/v3/api-docs/**");
    }

    @Override
    public void configure(HttpSecurity http) throws Exception {
        http.cors().and().csrf().disable().authorizeRequests()
                .antMatchers(PUBLIC_LIST)
                .permitAll()
                .antMatchers(ADMIN_LIST_PRIVATE)
                .hasAnyRole("ADMIN")
                .anyRequest().authenticated()
                .and()
                .sessionManagement()
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()
                .logout().clearAuthentication(true).invalidateHttpSession(true)
                .and()
                .addFilterBefore(jwtRequestFilter, UsernamePasswordAuthenticationFilter.class);
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        final CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(Arrays.asList("*"));
        configuration.setAllowedMethods(Arrays.asList("POST", "GET", "PUT", "DELETE", "HEAD", "OPTIONS"));
        configuration.setAllowCredentials(false);
        configuration.setAllowedHeaders(Arrays.asList("Authorization","Cache-Control","Content-Type"));
        final UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }

    String[] PUBLIC_LIST = {
//            "/api/test/post","/api/test/get/*","/api/test/put/*","/api/test/del/*",
            "/api/upload", "/api/files/*",
            "/api/chuc-vu/post","/api/chuc-vu/get/*","/api/chuc-vu/put/*","/api/chuc-vu/del/*",
            "/api/lop-hoc/post","/api/lop-hoc/get/*","/api/lop-hoc/put/*","/api/lop-hoc/del/*",
            "/api/nguoi-dung/create","/api/nguoi-dung/login","/api/nguoi-dung/get/*","/api/nguoi-dung/put/*","/api/nguoi-dung/del/*","/api/nguoi-dung/createAdmin","/api/nguoi-dung/change-pass/*",
            "/api/lich-phong-van/post","/api/lich-phong-van/get/*","/api/lich-phong-van/put/*","/api/lich-phong-van/del/*",
            "/api/phong-trao-su-kien/post","/api/phong-trao-su-kien/get/*","/api/phong-trao-su-kien/put/*","/api/phong-trao-su-kien/del/*",
            "/api/sinh-vien-dang-ky/post","/api/sinh-vien-dang-ky/get/*","/api/sinh-vien-dang-ky/put/*","/api/sinh-vien-dang-ky/del/*",
            "/api/sinh-vien-dang-ky/reset/*","/api/sinh-vien-dang-ky/pv/*","/api/sinh-vien-dang-ky/pass/*","/api/sinh-vien-dang-ky/fail/*",
            "/api/tnv-ptsk/post","/api/tnv-ptsk/get/*","/api/tnv-ptsk/put/*","/api/tnv-ptsk/del/*","/api/phong-trao-su-kien/get/soluongtnv/*","/api/tnv-ptsk/approve/*",
            "/api/poster/post","/api/poster/get/*","/api/poster/put/*","/api/poster/del/*",
    };

    String[] ADMIN_LIST_PRIVATE = {
    };

}
