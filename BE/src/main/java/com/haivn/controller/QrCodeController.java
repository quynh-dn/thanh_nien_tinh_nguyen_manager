package com.haivn.controller;

import com.haivn.dto.QrCodeDto;
import com.haivn.service.QrCodeService;
import com.google.zxing.NotFoundException;
import com.google.zxing.WriterException;
import io.swagger.v3.oas.annotations.Operation;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.Valid;
import java.io.IOException;
import java.util.Map;

@RequestMapping("/api/qrcode")
@RestController
@AllArgsConstructor
@Slf4j
public class QrCodeController {
    private final QrCodeService qrCodeService;

    @PostMapping("/generate")
    @ResponseStatus(value = HttpStatus.OK)
    @Operation(summary = "Sinh file QrCode và trả lại tên file ảnh Qr Code dạng png.")
    public ResponseEntity<Map<Integer, String>> qrCodeGenerationHandler(@Valid @RequestBody(required = true) final QrCodeDto qrCodeDto) throws IOException, WriterException {
        Map<Integer, String> res = qrCodeService.qrGenerate(qrCodeDto);
        return ResponseEntity.ok(res);
    }

//    @PostMapping("/contentGenerate")
//    @ResponseStatus(value = HttpStatus.OK)
//    @Operation(summary = "TESTTTTTTTTTTTTTTTTTTTTTTTTTTTT.")
//    public ResponseEntity<Map<Integer, String>> qrCodeGenerator(@Valid @RequestBody(required = true) final QrCodeDto qrCodeDto) throws IOException, WriterException {
//        Map<Integer, String> res = qrCodeService.yihuiQrGenerator(qrCodeDto);
//        return ResponseEntity.ok(res);
//    }

    @PutMapping(value = "/read", consumes = "multipart/form-data")
    @ResponseStatus(value = HttpStatus.OK)
    @Operation(summary = "Hiển thị thông tin đọc từ QR code.")
    public ResponseEntity<?> read(@RequestParam(value = "file", required = true) MultipartFile file) throws IOException, NotFoundException {
        return qrCodeService.read(file);
    }
}
