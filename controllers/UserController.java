package com.example.progettoAgenzia.controller;

import com.example.progettoAgenzia.models.Acquisto;
import com.example.progettoAgenzia.models.Cliente;
import com.example.progettoAgenzia.servicies.ClientService;
import com.example.progettoAgenzia.servicies.exceptions.UserNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
@RequestMapping("/user")
public class UserController {
    
    private final ClientService cs;
    
    @Autowired
    public UserController(ClientService cs) {
        this.cs = cs;
    }
    
    //metodi rest post loogin
    @GetMapping
    public ResponseEntity<Cliente> getCliente(@RequestParam String user) {
        try {
            return new ResponseEntity<>(cs.getCliente(user), HttpStatus.OK);
        } catch (UserNotFoundException e) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Cliente " + user + "non trovato", e);
        }
    }
    
    @GetMapping("/acquisti")
    public ResponseEntity<List<Acquisto>> getAcquisti(@RequestParam String user) {
        try {
            return new ResponseEntity<>(cs.getAcquisti(user), HttpStatus.OK);
        } catch (UserNotFoundException e) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Cliente " + user + "non trovato", e);
        }
    }
}
