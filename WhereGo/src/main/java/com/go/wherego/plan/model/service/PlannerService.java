package com.go.wherego.plan.model.service;

import java.util.ArrayList;

import com.go.wherego.plan.model.vo.Planner;

public interface PlannerService {

	//플래너 저장
	int insertPlanner(Planner planner);

	//플래너 리스트 가져오기
	ArrayList<Planner> selectPlanner(String userId);
	
	//플래너 조회
	Planner selectPlannerByNo(int plannerNo);

	//플래너 삭제하기
	int deletePlanner(int plannerNo);
}
