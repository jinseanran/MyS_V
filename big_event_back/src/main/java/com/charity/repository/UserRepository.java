package com.charity.repository;

import com.charity.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);
    boolean existsByUsername(String username);
    
    Page<User> findByRole(Integer role, Pageable pageable);
    Page<User> findByStatus(Integer status, Pageable pageable);
    Page<User> findByRoleAndStatus(Integer role, Integer status, Pageable pageable);
    
    long countByRole(Integer role);
}
