package com.charity.repository;

import com.charity.entity.Comment;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CommentRepository extends JpaRepository<Comment, Long> {
    
    Page<Comment> findByProjectIdOrderByCommentDateDesc(Long projectId, Pageable pageable);
    
    Page<Comment> findAllByOrderByCommentDateDesc(Pageable pageable);
    
    long countByStatus(Integer status);
}
