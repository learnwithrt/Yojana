package com.yojana.repos;
import org.springframework.data.jpa.repository.JpaRepository;

import com.yojana.entities.Project;

public interface ProjectRepository extends JpaRepository<Project, Integer> {

}