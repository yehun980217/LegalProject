package com.kpaas.kpaasproject.mapper;

import com.kpaas.kpaasproject.dto.UserDTO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AdminMapper {
    int insertAdmin(UserDTO userDto);
}
