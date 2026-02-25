package com.charity.controller;

import com.charity.dto.Result;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/file")
@CrossOrigin
public class FileController {

    @Value("${file.upload.path:./uploads}")
    private String uploadPath;

    @PostMapping("/upload")
    public Result<Map<String, String>> upload(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            return Result.error("请选择文件");
        }

        try {
            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            String newFilename = UUID.randomUUID().toString() + extension;

            String absoluteUploadPath = new File(uploadPath).getAbsolutePath();
            Path path = Paths.get(absoluteUploadPath);
            if (!Files.exists(path)) {
                Files.createDirectories(path);
            }

            File destFile = new File(absoluteUploadPath + File.separator + newFilename);
            file.transferTo(destFile);

            Map<String, String> data = new HashMap<>();
            data.put("url", "/uploads/" + newFilename);
            data.put("filename", newFilename);

            return Result.success(data);
        } catch (IOException e) {
            e.printStackTrace();
            return Result.error("文件上传失败: " + e.getMessage());
        }
    }
}
