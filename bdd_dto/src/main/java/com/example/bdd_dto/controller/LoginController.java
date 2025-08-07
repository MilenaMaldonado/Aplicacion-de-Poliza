package com.example.bdd_dto.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/login")
public class LoginController {
    // Usuario y contraseña hardcodeados para demo
    private static final String USER = "admin";
    private static final String PASS = "admin";

    @PostMapping
    public ResponseEntity<?> login(@RequestBody LoginRequest req) {
        if (USER.equals(req.getUsuario()) && PASS.equals(req.getPassword())) {
            return ResponseEntity.ok().body("Login correcto");
        } else {
            return ResponseEntity.status(401).body("Credenciales incorrectas");
        }
    }

    public static class LoginRequest {
        private String usuario;
        private String password;
        public String getUsuario() { return usuario; }
        public void setUsuario(String usuario) { this.usuario = usuario; }
        public String getPassword() { return password; }
        public void setPassword(String password) { this.password = password; }
    }
}
