package com.catdog.times.common.util;

import lombok.ToString;

@ToString
public class PageInfo {
	private int currentPage;
	
	private int pageLimit;
	
	private int listCount;
	
	private int listLimit;	
	
	public PageInfo(int currentPage, int pageLimit, int listCount, int listLimit) {
		this.currentPage = currentPage;
		this.pageLimit = pageLimit;
		this.listCount = listCount;
		this.listLimit = listLimit;
	}
	
	public int getListLimit() {
		return listLimit;
	}

	public int getMaxPage() {

		return (int) Math.ceil((double) this.listCount / this.listLimit);
	}
	
	public int getStartPage() {
		/*	
			< 1 2 3 4 5 6 7 8 9 10 >
			< 11 12 13 14 15 16 17 18 19 20 >
			< 21 22 23 24 25 26 27 28 29 30 >
			
			1, 11, 21, 31, .... => (10 * n) + 1 (n >= 0)
			
			1 ~ 10 : n = 0
			11 ~ 20 : n = 1
			21 ~ 30 : n = 2
			31 ~ 40 : n = 3 
			.... 
			n = (currentPage - 1) / pageLimit
			
			(10 * ((currentPage - 1) / pageLimit)) + 1 (n >= 0)
		 */
		return (this.pageLimit * ((this.currentPage - 1) / this.pageLimit)) + 1;
	  }

	public int getEndPage() {
		// 10, 20, 30, 40, .... 
		
		int endPage = this.getStartPage() + this.pageLimit - 1;
		
		return endPage > this.getMaxPage() ? this.getMaxPage() : endPage;
	}	
	
	public int getCurrentPage() {
		return this.currentPage;
	}
	
	public int getPrevPage() {
		int prevPage = this.getCurrentPage() - 1;
		
		return prevPage < 1 ? 1 : prevPage;
	}
	
	public int getNextPage() {
		int nextPage = this.getCurrentPage() + 1;
		
		return nextPage > this.getMaxPage() ? this.getMaxPage() : nextPage;
	}
	
	public int getStartList() {
		return (this.getCurrentPage() - 1) * this.listLimit + 1;
	}
	
	public int getEndList() {
		int endList = this.getStartList() + this.listLimit - 1;
		
		return endList > this.listCount ? this.listCount : endList;
	}
}




