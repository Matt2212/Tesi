package com.example.progettoAgenzia.controller;

import com.example.progettoAgenzia.models.Recensione;
import com.example.progettoAgenzia.servicies.ReviewService;
import com.example.progettoAgenzia.servicies.exceptions.LocalityNotFoundException;
import com.example.progettoAgenzia.servicies.exceptions.UserNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/review")

public class ReviewController {
    
    private final ReviewService rs;
    
    @Autowired
    public ReviewController(ReviewService rs) {
        this.rs = rs;
    }
    
    @GetMapping("/{localita}")
    public ResponseEntity<List<Recensione>> getReviews(@PathVariable("localita") String localita) {
        return new ResponseEntity<>(rs.getRecensioni(localita), HttpStatus.OK);
    }
    
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public void addReview(@Valid @RequestBody Recensione r) {
        try {
            rs.addReview(r);
        } catch (UserNotFoundException e) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Utente " + r.getId().getCliente() + " non trovato", e);
        } catch (LocalityNotFoundException e) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, e.getMessage(), e);
        }
    }
    
    
}


