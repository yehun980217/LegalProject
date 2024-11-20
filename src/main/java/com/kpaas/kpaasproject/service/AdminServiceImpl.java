package com.kpaas.kpaasproject.service;

import com.kpaas.kpaasproject.dto.UserDTO;
import com.kpaas.kpaasproject.mapper.AdminMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AdminServiceImpl implements AdminService{

    @Autowired
    AdminMapper adminMapper;
    @Override
    public int insertAdmin(UserDTO userDto) {
        return adminMapper.insertAdmin(userDto);
    }
}
