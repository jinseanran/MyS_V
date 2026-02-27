package com.charity.service;

import com.charity.entity.DonationProject;
import com.charity.entity.UserPreference;
import com.charity.repository.DonationProjectRepository;
import com.charity.repository.UserPreferenceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class RecommendationService {

    @Autowired
    private UserPreferenceRepository userPreferenceRepository;

    @Autowired
    private DonationProjectRepository donationProjectRepository;

    public List<DonationProject> getRecommendations(Long userId, int limit) {
        List<UserPreference> preferences = userPreferenceRepository.findByUserIdOrderByScoreDesc(userId);

        if (preferences.isEmpty()) {
            return getPopularProjects(limit);
        }

        List<String> preferredCategories = preferences.stream()
                .map(UserPreference::getCategory)
                .collect(Collectors.toList());

        List<DonationProject> allProjects = donationProjectRepository.findByStatusOrderByCreateTimeDesc(1);
        
        List<DonationProject> recommended = allProjects.stream()
                .filter(project -> preferredCategories.contains(project.getCategory()))
                .collect(Collectors.toList());

        if (recommended.size() < limit) {
            List<DonationProject> otherProjects = allProjects.stream()
                    .filter(project -> !preferredCategories.contains(project.getCategory()))
                    .collect(Collectors.toList());
            
            int needed = limit - recommended.size();
            recommended.addAll(otherProjects.stream().limit(needed).collect(Collectors.toList()));
        }

        return recommended.stream().limit(limit).collect(Collectors.toList());
    }

    private List<DonationProject> getPopularProjects(int limit) {
        return donationProjectRepository.findByStatusOrderByCreateTimeDesc(1).stream()
            .limit(limit)
            .collect(Collectors.toList());
    }

    @Transactional
    public void recordView(Long userId, String category) {
        updatePreference(userId, category, "view");
    }

    @Transactional
    public void recordDonation(Long userId, String category) {
        updatePreference(userId, category, "donation");
    }

    private void updatePreference(Long userId, String category, String action) {
        Optional<UserPreference> existingOpt = userPreferenceRepository.findByUserIdAndCategory(userId, category);
        UserPreference preference;

        if (existingOpt.isPresent()) {
            preference = existingOpt.get();
        } else {
            preference = new UserPreference();
            preference.setUserId(userId);
            preference.setCategory(category);
            preference.setViewCount(0);
            preference.setDonationCount(0);
            preference.setScore(0.0);
        }

        Integer currentViewCount = preference.getViewCount() != null ? preference.getViewCount() : 0;
        Integer currentDonationCount = preference.getDonationCount() != null ? preference.getDonationCount() : 0;
        Double currentScore = preference.getScore() != null ? preference.getScore() : 0.0;

        if ("view".equals(action)) {
            preference.setViewCount(currentViewCount + 1);
            preference.setScore(currentScore + 0.5);
        } else if ("donation".equals(action)) {
            preference.setDonationCount(currentDonationCount + 1);
            preference.setScore(currentScore + 3.0);
        }

        userPreferenceRepository.save(preference);
    }

    public List<UserPreference> getUserPreferences(Long userId) {
        return userPreferenceRepository.findByUserIdOrderByScoreDesc(userId);
    }
}
