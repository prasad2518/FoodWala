package com.tap.controlers;

import java.io.IOException;
import java.util.List;

import com.tap.daoimpl.MenuDaoImpl;
import com.tap.model.Menu;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/menu")

public class MenuController  extends HttpServlet{
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		MenuDaoImpl   menudao =new MenuDaoImpl();
		
		int restaurantId  =Integer.parseInt(req.getParameter("restaurantId"));
		
		 List<Menu>menulist=menudao.getMenusByRestaurantId(restaurantId);
		 
		 req.setAttribute("menuList", menulist);
		   RequestDispatcher rd= req.getRequestDispatcher("menu.jsp");
		      rd.forward(req, resp);
//		super.doGet(req, resp);
	}
}
