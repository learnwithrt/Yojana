package com.yojana.controllers;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.yojana.entities.Project;
import com.yojana.entities.Task;
import com.yojana.entities.User;
import com.yojana.services.ProjectService;
import com.yojana.services.TaskService;
import com.yojana.services.UserService;

@Controller
public class TaskController {
	@Autowired
	UserService service;
	@Autowired
	ProjectService projService;
	@Autowired
	TaskService taskService;

	@GetMapping("/addTask/{id}")
	public String showNewTask(Model model, @PathVariable String id) {
		List<User> user = new ArrayList<>();
		List<User> users = service.listAll();
		Project project = projService.get(Integer.parseInt(id));
		model.addAttribute("userList", users);
		model.addAttribute("user", user);
		model.addAttribute("project", project);
		return "addTask";
	}

	@PostMapping("/newTask.html")
	public String addTask(Model model, @RequestParam("task_name") String name,
			@RequestParam("task_desc") String desc, @RequestParam("proj_id") String proj_id,
			@RequestParam("task_start_date") String start_date, @RequestParam("task_end_date") String end_date,
			@RequestParam("task_manager") String manager, HttpServletRequest request) {
		Task task = null;
		SimpleDateFormat in = new SimpleDateFormat("dd-MM-yyyy");
		try {
			task = new Task(name, Integer.parseInt(proj_id), in.parse(start_date), in.parse(end_date), desc, manager,
					-1);
		} catch (NumberFormatException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		taskService.save(task);
		return "redirect:manager.html";
	}
}
