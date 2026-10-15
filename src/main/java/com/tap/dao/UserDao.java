package com.tap.dao;

import java.util.List;
import com.tap.model.User;

public interface UserDao {

    void addUser(User user);

    User getUserById(int userId);

    List<User> getAllUsers();

    void updateUser(User user);
    User getUserByEmail(String email);

    void deleteUser(int userId);
}