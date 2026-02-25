package com.charity.controller;

import org.springframework.data.domain.Page;
import com.charity.dto.DonationResponse;
import com.charity.dto.Result;
import com.charity.entity.DonationProject;
import com.charity.entity.DonationRecord;
import com.charity.service.DonationProjectService;
import com.charity.utils.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;

@RestController
@RequestMapping("/project")
@CrossOrigin
public class DonationProjectController {

    @Autowired
    private DonationProjectService projectService;

    @Autowired
    private JwtUtil jwtUtil;

    @GetMapping("/list")
    public Result<Page<DonationProject>> getProjectList(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) Integer status) {
        return projectService.getProjectList(pageNum, pageSize, category, status);
    }

    @GetMapping("/detail/{id}")
    public Result<DonationProject> getProjectDetail(@PathVariable Long id) {
        return projectService.getProjectDetail(id);
    }

    @PostMapping("/create")
    public Result<Void> createProject(@RequestBody DonationProject project) {
        return projectService.createProject(project);
    }

    @PutMapping("/update")
    public Result<Void> updateProject(@RequestBody DonationProject project) {
        return projectService.updateProject(project);
    }

    @PutMapping("/thank/{id}")
    public Result<Void> updateThankMessage(
            @PathVariable Long id,
            @RequestParam String thankMessage) {
        DonationProject project = new DonationProject();
        project.setId(id);
        project.setThankMessage(thankMessage);
        return projectService.updateProject(project);
    }

    @DeleteMapping("/delete/{id}")
    public Result<Void> deleteProject(@PathVariable Long id) {
        return projectService.deleteProject(id);
    }

    @PostMapping("/donate")
    public Result<DonationResponse> donate(
            @RequestHeader("Authorization") String token,
            @RequestParam Long projectId,
            @RequestParam BigDecimal amount,
            @RequestParam(required = false) String message,
            @RequestParam(required = false, defaultValue = "0") Integer isAnonymous) {
        Long userId = jwtUtil.getUserId(token.replace("Bearer ", ""));
        return projectService.donate(userId, projectId, amount, message, isAnonymous);
    }
}
