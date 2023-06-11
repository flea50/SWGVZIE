<?php

	class Ingreso extends Controllers{

		public function __construct()
		{
			parent::__construct();
			session_start();
			session_regenerate_id(true);
			if(empty($_SESSION['login']))
			{
				header('Location: '.base_url().'/login');
			}
			getPermisos(4);
		}

		public function Ingreso()
		{
			if(empty($_SESSION['permisosMod']['r'])){
				header("Location:".base_url().'/dashboard');
			}
			$data['page_tag'] = "Ingreso";
			$data['page_title'] = "Ingresos <small>Tienda Virtual</small>";
			$data['page_name'] = "Ingreso";
			$data['page_functions_js'] = "functions_ingreso.js";
			$this->views->getView($this,"ingreso",$data);
		}

	}


 ?>