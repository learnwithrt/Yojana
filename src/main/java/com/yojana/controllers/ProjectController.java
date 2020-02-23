package com.yojana.controllers;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.tomcat.util.http.fileupload.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.yojana.entities.Project;
import com.yojana.entities.User;
import com.yojana.services.ProjectService;
import com.yojana.services.UserService;

@Controller
public class ProjectController {
	@Autowired
	UserService service;
	@Autowired
	ProjectService projService;

	@GetMapping("/manager.html")
	public String showManager(Model model) {
		List<Project> project = new ArrayList<>();
		List<Project> projects = projService.listAll();
		model.addAttribute("projectList", projects);
		model.addAttribute("project", project);
		return "manager";
	}

	@GetMapping("/project/{id}")
	public String showProjectDetails(@PathVariable String id,Model model) {
		Project proj = projService.get(Integer.parseInt(id));
		model.addAttribute("project",proj);
		List<User> user = new ArrayList<>();
		List<User> users = service.listAll();
		model.addAttribute("userList", users);
		model.addAttribute("user", user);
		return "project";
	}

	
	@GetMapping("/project/avatar/{id}")
	public void showProjectAvatar(@PathVariable String id, HttpServletResponse response) throws IOException {
		System.out.println("ID"+id);
		Project proj = projService.get(Integer.parseInt(id));
		response.setContentType("image/jpeg");
		InputStream is = new ByteArrayInputStream(proj.getProject_photo());
		IOUtils.copy(is, response.getOutputStream());
	}

	@GetMapping("/addProject.html")
	public String showNewProject(Model model) {
		List<User> user = new ArrayList<>();
		List<User> users = service.listAll();
		model.addAttribute("userList", users);
		model.addAttribute("user", user);
		return "addProject";
	}

	@PostMapping("newProject.html")
	public String addProject(Model model, @RequestParam("proj_name") String name,
			@RequestParam("proj_desc") String desc, @RequestParam("proj_duration") String duration,
			@RequestParam("proj_manager") String manager, @RequestParam("proj_pic") MultipartFile proj_pic,
			HttpServletRequest request) {
		Project proj = null;
		try {
			proj = new Project(name, desc, Integer.parseInt(duration), manager, proj_pic.getBytes());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		projService.save(proj);
		return "redirect:manager.html";
	}
	@PostMapping("project/updateProject.html")
	public String updateProject(Model model, @RequestParam("proj_id") String id,@RequestParam("proj_name") String name,
			@RequestParam("proj_desc") String desc, @RequestParam("proj_duration") String duration,
			@RequestParam("proj_manager") String manager, @RequestParam("proj_pic") MultipartFile proj_pic,
			HttpServletRequest request) {
		Project project=projService.get(Integer.parseInt(id));
		project.setProject_description(desc);
		project.setProject_Duration(Integer.parseInt(duration));
		project.setProject_name(name);
		try {
			project.setProject_photo(proj_pic.getBytes());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		project.setProject_Manager(manager);
		projService.save(project);
		return "redirect:../manager.html";
	}
	
	@GetMapping("deleteproject/{id}")
	public String deleteProject(@PathVariable String id) {
		projService.delete(Integer.parseInt(id));
		return "redirect:../manager.html";
	}
}
