package com.haivn.controller;


import com.haivn.dto.OneSignalDto;
import com.haivn.dto.ThongbaoDto;
import com.haivn.repository.OneSignalRepository;
import com.haivn.service.OneSignalService;
import com.haivn.service.ThongbaoService;
import io.swagger.v3.oas.annotations.Operation;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/push")
public class OneSignalController {
    @Autowired
    private OneSignalRepository repository;

    private final OneSignalService oneSignalService;
    private final ThongbaoService thongbaoService;

    @Value("${onesignal.enable}")
    private boolean oneSignalEnable;

    public OneSignalController(OneSignalService oneSignalService,
                               ThongbaoService thongbaoService){
        this.oneSignalService = oneSignalService;
        this.thongbaoService = thongbaoService;
    }

//    @PostMapping("/allUsers")
//    public ResponseEntity<Boolean> sendMessageToAllUsers(@RequestBody Map<String,String> params)
//    {
//        String title = params.get("title");
//        String message = params.get("message");
//        String url = params.get("url");
//        String bigImage = params.get("bigImage");
//        if((null != title && title.length()>255) || (null != message && message.length()>255))
//            return ResponseEntity.ok(false);
//
//        OneSignalDto dto = new OneSignalDto();
//        dto.setTitle(title);
//        dto.setMessage(message);
//        dto.setUrl(url);
//        dto.setBigImage(bigImage);
//        try {
//            oneSignalService.sendMessageToAllUsers(dto);
//        }
//        catch (Exception e){}
//
//        return ResponseEntity.ok(true);
//    }

    @Operation(summary = "Gửi thông báo theo thẻ user tags")
    @PostMapping("/tags/{tagName}/{tagValue}")
    public ResponseEntity<Boolean> sendMessageToAamUser(@PathVariable("tagName") String tagName,
                                        @PathVariable("tagValue") String tagValue,
                                        @RequestBody Map<String,String> params)
    {
        List<String> tagValues = Arrays.asList(tagValue.split("&"));

        String title = params.get("title");
        String message = params.get("message");
        String url = params.get("url");
        String bigImage = params.get("bigImage");
        if((null != title && title.length()>255) || (null != message && message.length()>255))
            return ResponseEntity.ok(false);

        OneSignalDto dto = new OneSignalDto();
        dto.setTitle(title);
        dto.setMessage(message);
        dto.setUrl(url);
        dto.setBigImage(bigImage);
        try{
            if(oneSignalEnable)
                oneSignalService.sendMessageByTags(dto, tagName, tagValues, "admin");
        }
        catch (Exception e){}
        List<ThongbaoDto> lstThongbaoDto = new LinkedList<>();
        for(String val : tagValues) {
            if(StringUtils.isNotEmpty(val)) {
                ThongbaoDto tbDto = new ThongbaoDto();
                tbDto.setTitle(title);
                tbDto.setMessage(message);
                tbDto.setUrl(url);
                tbDto.setImage(bigImage);
                tbDto.setTagName(tagName);
                tbDto.setTagValue(val);
                tbDto.setLevel(0);
                lstThongbaoDto.add(tbDto);
            }
        }
        return ResponseEntity.ok(thongbaoService.saveAll(lstThongbaoDto));
    }

    @Operation(summary = "Gửi thông báo theo mã phòng ban, chức vụ")
    @PostMapping("/duty/{departId}/{level}")
    public ResponseEntity<Boolean> sendMessageToAamUser(@PathVariable("departId") int departId,
                                                        @PathVariable("level") String level,
                                                        @RequestBody Map<String,String> params)
    {
        List<String> levelValues = Arrays.asList(level.split("&"));

        String title = params.get("title");
        String message = params.get("message");
        String url = params.get("url");
        String bigImage = params.get("bigImage");
        if((null != title && title.length()>255) || (null != message && message.length()>255))
            return ResponseEntity.ok(false);

        OneSignalDto dto = new OneSignalDto();
        dto.setTitle(title);
        dto.setMessage(message);
        dto.setUrl(url);
        dto.setBigImage(bigImage);
        try{
            if(oneSignalEnable)
                oneSignalService.sendMessageToDepartByTags(dto, departId, levelValues);
        }
        catch (Exception e){}
        List<ThongbaoDto> lstThongbaoDto = new LinkedList<>();
        for(String val : levelValues) {
            if(StringUtils.isNotEmpty(val)) {
                ThongbaoDto tbDto = new ThongbaoDto();
                tbDto.setTitle(title);
                tbDto.setMessage(message);
                tbDto.setUrl(url);
                tbDto.setImage(bigImage);
                tbDto.setTagName("level");
                tbDto.setTagValue(val);
                tbDto.setLevel(Integer.parseInt(val));
                lstThongbaoDto.add(tbDto);
            }
        }
        return ResponseEntity.ok(thongbaoService.saveAll(lstThongbaoDto));
    }

    @PostMapping("/guest/{tagName}/{tagValue}")
    public ResponseEntity<Boolean> sendMessageToGuest(@PathVariable("tagName") String tagName,
                                                           @PathVariable("tagValue") String tagValue,
                                                           @RequestBody Map<String,String> params)
    {
        List<String> tagValues = Arrays.asList(tagValue.split("&"));

        String title = params.get("title");
        String message = params.get("message");
        String url = params.get("url");
        String bigImage = params.get("bigImage");
        if((null != title && title.length()>255) || (null != message && message.length()>255))
            return ResponseEntity.ok(false);

        OneSignalDto dto = new OneSignalDto();
        dto.setTitle(title);
        dto.setMessage(message);
        dto.setUrl(url);
        dto.setBigImage(bigImage);
        try{
            if(oneSignalEnable)
                oneSignalService.sendMessageByTags(dto, tagName, tagValues,"guest");
        }
        catch (Exception e){}
        List<ThongbaoDto> lstThongbaoDto = new LinkedList<>();
        for(String val : tagValues) {
            if(StringUtils.isNotEmpty(val)) {
                ThongbaoDto tbDto = new ThongbaoDto();
                tbDto.setTitle(title);
                tbDto.setMessage(message);
                tbDto.setUrl(url);
                tbDto.setImage(bigImage);
                tbDto.setTagName(tagName);
                tbDto.setTagValue(val);
                tbDto.setLevel(0);
                lstThongbaoDto.add(tbDto);
            }
        }
        return ResponseEntity.ok(thongbaoService.saveAll(lstThongbaoDto));
    }

//    @PostMapping("/toUser/{userId}")
//    public void sendMessageToUser(@PathVariable("userId") String userId,
//                                  @RequestBody Map<String,String> params)
//    {
//        String title = params.get("title");
//        String message = params.get("message");
//        oneSignalService.sendMessageToUser(title, message, userId);
//    }

//    @PostMapping("/save/{userId}")
//    public void saveUserId(@PathVariable("userId") String userId)
//    {
//        OneSignal notification = new OneSignal();
//        notification.setIdOneSignal(userId);
//        notification.setUserName("User: " + userId);
//        repository.save(notification);
//    }
//
//    @GetMapping("/getUsers")
//    public List<Object> getUsers()
//    {
//        List<Object> listValues = new ArrayList<>();
//        for (OneSignal notification : repository.findAll()){
//            Map<String, Object> mapValues = new HashMap<>();
//            mapValues.put("userName", notification.getUserName());
//            mapValues.put("idOneSignal", notification.getIdOneSignal());
//            listValues.add(mapValues);
//        }
//
//        return listValues;
//    }
}
