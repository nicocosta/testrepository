
@page { 
	size: A4;
	margin-top: 40px;
	margin-bottom: 40px;
	margin-left: 30px;
	margin-right: 30px;
	
	@top-left {
		content: element(header_left);
	}
	
	@top-center {
		content: element(header_center);
	}
	
	@top-right {
		content: element(header_right);
	}
	
	@bottom-left {
		content: element(footer_left);
	}
	
	@bottom-center {
		content: element(footer_center);
	}
	
	@bottom-right {
		content: element(footer_right);
	}
}






h1 {

    font-size: 120%;
    font-weight: bold;
    padding-left: 2px;
    border-bottom: 2px solid black;
}

.imgClass {

    padding-bottom: 50px;
}

.labelCol {

    color: #4A4A56;
    padding-bottom: 5px;
    padding-top: 5px;
    width: 15%;
    font-size: 80%;
    font-weight: bold;
    text-align: right;
    vertical-align: top;      
}

.dataCol {

    width: 35%;
    text-align: left;
    border-right: medium none;
    margin-left: 4px;
    padding-left: 10px;
    font-size: 75%;
    color:black;
    text-decoration:none;
    cursor:default;
}


.tertiaryPalette {

    border-top: 2px solid black;
    font-size: 85%;
    font-weight: bold;
    margin-bottom: 4px;
    margin-top: 4px;
    overflow: hidden;
}

.pbHeader {
    background-color: #FFFFFF;
    border-bottom: 2px solid black;
    margin: 0;
    padding: 15px 2px 2px 4px;
    font-size: 80%;
    font-weight: bold;
}

.list {
    width: 100%;
    padding: 0;
}

.list th {
    border-left: medium none;
    border-right: 1px solid #EEEEEE;
    font-weight: normal;
    padding-left: 4px;
    padding-bottom: 4px;
    text-align: right;
    width: 15%;
    font-size: 75%;
}

.list td {
    border-left-color: #EEEEEE;
    font-weight: bold;
    padding-left: 4px;
    padding-bottom: 4px;
    text-align: left;
    width: 85%;
    font-size: 75%;
}






.header_left {
	text-align: left;
    position: running(header_left);
}

.header_center{
	text-align: center;
	position: running(header_center);
}

.header_right {
	text-align: right;
	position: running(header_right);
}

.footer_left {
	text-align: left;
	position: running(footer_left);
}

.footer_center {
	text-align: center;
	position: running(footer_center);
}

.footer_right {
	text-align: right;
	position: running(footer_right);
}

.pageNumber:before {
	content: counter(page); 
}

.pageCount:before {
	content: counter(pages);  
}
