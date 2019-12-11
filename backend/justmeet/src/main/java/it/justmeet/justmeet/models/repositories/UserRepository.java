package it.justmeet.justmeet.models.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import it.justmeet.justmeet.models.User;
import it.justmeet.justmeet.models.UserInterface;

@Repository
public interface UserRepository extends JpaRepository<UserInterface, Long> {
    UserInterface findByUid(String uid);
}