package com.example.progettoAgenzia.controller;

import com.example.progettoAgenzia.models.Acquisto;
import com.example.progettoAgenzia.servicies.AcquistoService;
import com.example.progettoAgenzia.servicies.exceptions.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@RequestMapping("/cart")
@RestController
public class CartController {
    
    private final AcquistoService as;
    
    @Autowired
    public CartController(AcquistoService as) {
        this.as = as;
    }
    
    @GetMapping
    //Restituisce un nuovo carrello
    public ResponseEntity<Acquisto> getCart() {
        return new ResponseEntity<>(as.getNewCarrello(), HttpStatus.OK);
    }
    
    //unisce un  carrello temporaneo con quello di un utente dato un nome utente
    @PutMapping
    public ResponseEntity<Acquisto> mergeCart(@RequestParam String id, @RequestParam String username) {
        try {
            Acquisto acquisto = as.mergeCarrello(Long.parseLong(id), username);
            return new ResponseEntity<>(acquisto, HttpStatus.OK);
        } catch (UserNotFoundException e) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Utente " + username + " non trovato ", e);
        } catch (AcquistoException e) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Carrello dell' utente" + username + " non trovato ", e);
        }
    }
    
    //salva il carrello
    @PutMapping("/save")
    public void saveCart(@RequestBody Acquisto a) {
        try {
            as.saveCart(a);
        } catch (VacantionPackageNotFoundException e) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Pacchetto vacanza non trovato", e);
        } catch (AcquistoException e) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Carrello non trovato", e);
        }
    }
    
    @PutMapping("/acquisto")
    public ResponseEntity<Acquisto> effettuaAcquisto(@RequestBody Acquisto a) {
        try {
            return new ResponseEntity<>(as.effettuaAcquisto(a), HttpStatus.OK);
        } catch (AcquistoException | ModifiedPriceException | NoSuchReservationException e) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, e.getMessage(), e);
        } catch (VacantionPackageNotFoundException e) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Pacchetto vacanza non trovato", e);
        }
    }
    
}
