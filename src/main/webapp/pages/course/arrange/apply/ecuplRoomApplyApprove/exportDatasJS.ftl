	    function exportData() {
	        addInput(form,"keys","activityName,schoolDistrict.name,classroomNames,classroomTypeNames,capacityOfCourse,approveBy.userName,borrower.mobile,applyAt,applyTime,approveBy.userName,approveAt,isMultimedia")
	        addInput(form,"titles","活动名称,借用校区,批准教室,教室类型,教室容量,借用人,借用人电话,提交申请时间,申请占用时间,审核人,审核时间,多媒体使用情况");
	    	form.action ="?method=export";
	    	addHiddens(form, queryStr);
	    	form.submit();
	    }