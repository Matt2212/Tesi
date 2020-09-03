package com.example.progettoAgenzia.controller;

import com.example.progettoAgenzia.models.Localita;
import com.example.progettoAgenzia.models.PacchettoVacanza;
import com.example.progettoAgenzia.servicies.LocalitaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/localita")
public class LocalitaController {
    
    private final LocalitaService ls;
    
    @Autowired
    public LocalitaController(LocalitaService ls) {
        this.ls = ls;
    }
    
    @GetMapping
    public ResponseEntity<List<Localita>> searchLocalita() {
        return new ResponseEntity<>(ls.search(), HttpStatus.OK);
    }
    
    @GetMapping("/pacchetti")
    public ResponseEntity<List<PacchettoVacanza>> searchPacchetti(@RequestParam String l) {
        return new ResponseEntity<>(ls.searchPacchetti(l), HttpStatus.OK);
    }
}
