/**
 * Copyright (c) 2011-2019, James Zhan 詹波 (jfinal@126.com).
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.jfinal.config;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import com.jfinal.aop.Interceptor;
import com.jfinal.aop.InterceptorManager;
import com.jfinal.core.Controller;
import com.jfinal.kit.StrKit;

/**
 * Routes.
 */
public abstract class Routes {
	
	private static List<Routes> routesList = new ArrayList<Routes>();
	private static Set<String> controllerKeySet = new HashSet<String>();
	
	static final boolean DEFAULT_MAPPING_SUPER_CLASS = false;	// 是否映射超类中的方法为路由的默认值
	Boolean mappingSuperClass = null;							// 是否映射超类中的方法为路由
	
	private String baseViewPath = null;
	private List<Route> routeItemList = new ArrayList<Route>();
	private List<Interceptor> interList = new ArrayList<Interceptor>();
	
	private boolean clearAfterMapping = false;
	
	/**
	 * Implement this method to add route, add interceptor and set baseViewPath
	 */
	public abstract void config();
	
	/**
	 * 设置是否映射超类中的方法为路由，默认值为 false
	 * 
	 * 以免 BaseController extends Controller 用法中的 BaseController 中的方法被映射成 action
	 */
	public Routes setMappingSuperClass(boolean mappingSuperClass) {
		this.mappingSuperClass = mappingSuperClass;
		return this;
	}
	
	public boolean getMappingSuperClass() {
		return mappingSuperClass != null ? mappingSuperClass : DEFAULT_MAPPING_SUPER_CLASS;
	}
	
	/**
	 * Add Routes
	 */
	public Routes add(Routes routes) {
		routes.config();
		
		/**
		 * 如果子 Routes 没有配置 mappingSuperClass，则使用顶层 Routes 的配置
		 * 主要是为了让 jfinal weixin 用户有更好的体验
		 * 
		 * 因为顶层 Routes 和模块级 Routes 配置都可以生效，减少学习成本
		 */
		if (routes.mappingSuperClass == null) {
			routes.mappingSuperClass = this.mappingSuperClass;
		}
		
		routesList.add(routes);
		return this;
	}
	
	/**
	 * Add route
	 * @param controllerKey A key can find controller
	 * @param controllerClass Controller Class
	 * @param viewPath View path for this Controller
	 */
	public Routes add(String controllerKey, Class<? extends Controller> controllerClass, String viewPath) {
		routeItemList.add(new Route(controllerKey, controllerClass, viewPath));
		return this;
	}
	
	/**
	 * Add route. The viewPath is controllerKey
	 * @param controllerKey A key can find controller
	 * @param controllerClass Controller Class
	 */
	public Routes add(String controllerKey, Class<? extends Controller> controllerClass) {
		return add(controllerKey, controllerClass, controllerKey);
	}
	
	/**
	 * Add interceptor for controller in this Routes
	 */
	public Routes addInterceptor(Interceptor interceptor) {
		if (com.jfinal.aop.AopManager.me().isInjectDependency()) {
			com.jfinal.aop.Aop.inject(interceptor);
		}
		interList.add(interceptor);
		return this;
	}
	
	/**
	 * Set base view path for controller in this routes
	 */
	public Routes setBaseViewPath(String baseViewPath) {
		if (StrKit.isBlank(baseViewPath)) {
			throw new IllegalArgumentException("baseViewPath can not be blank");
		}
		
		baseViewPath = baseViewPath.trim();
		if (! baseViewPath.startsWith("/")) {			// add prefix "/"
			baseViewPath = "/" + baseViewPath;
		}
		if (baseViewPath.endsWith("/")) {				// remove "/" in the end of baseViewPath
			baseViewPath = baseViewPath.substring(0, baseViewPath.length() - 1);
		}
		
		this.baseViewPath = baseViewPath;
		return this;
	}
	
	public String getBaseViewPath() {
		return baseViewPath;
	}
	
	public List<Route> getRouteItemList() {
		return routeItemList;
	}
	
	public Interceptor[] getInterceptors() {
		return interList.size() > 0 ?
				interList.toArray(new Interceptor[interList.size()]) :
				InterceptorManager.NULL_INTERS;
	}
	
	public static List<Routes> getRoutesList() {
		return routesList;
	}
	
	public static Set<String> getControllerKeySet() {
		return controllerKeySet;
	}
	
	/**
	 * 配置是否在路由映射完成之后清除内部数据，以回收内存，默认值为 true.
	 * 
	 * 设置为 false 通常用于在系统启动之后，仍然要使用 Routes 的场景，
	 * 例如希望拿到 Routes 生成用于控制访问权限的数据
	 */
	public void setClearAfterMapping(boolean clearAfterMapping) {
		this.clearAfterMapping = clearAfterMapping;
	}
	
	public void clear() {
		if (clearAfterMapping) {
			routesList = null;
			controllerKeySet = null;
			baseViewPath = null;
			routeItemList = null;
			interList = null;
		}
	}
	
	public static class Route {
		
		private String controllerKey;
		private Class<? extends Controller> controllerClass;
		private String viewPath;
		
		public Route(String controllerKey, Class<? extends Controller> controllerClass, String viewPath) {
			if (StrKit.isBlank(controllerKey)) {
				throw new IllegalArgumentException("controllerKey can not be blank");
			}
			if (controllerClass == null) {
				throw new IllegalArgumentException("controllerClass can not be null");
			}
			if (StrKit.isBlank(viewPath)) {
				// throw new IllegalArgumentException("viewPath can not be blank");
				viewPath = "/";
			}
			
			this.controllerKey = processControllerKey(controllerKey);
			this.controllerClass = controllerClass;
			this.viewPath = processViewPath(viewPath);
		}
		
		private String processControllerKey(String controllerKey) {
			controllerKey = controllerKey.trim();
			if (!controllerKey.startsWith("/")) {
				controllerKey = "/" + controllerKey;
			}
			if (controllerKeySet.contains(controllerKey)) {
				throw new IllegalArgumentException("controllerKey already exists: " + controllerKey);
			}
			controllerKeySet.add(controllerKey);
			return controllerKey;
		}
		
		private String processViewPath(String viewPath) {
			viewPath = viewPath.trim();
			if (!viewPath.startsWith("/")) {			// add prefix "/"
				viewPath = "/" + viewPath;
			}
			if (!viewPath.endsWith("/")) {				// add postfix "/"
				viewPath = viewPath + "/";
			}
			return viewPath;
		}
		
		public String getControllerKey() {
			return controllerKey;
		}
		
		public Class<? extends Controller> getControllerClass() {
			return controllerClass;
		}
		
		public String getFinalViewPath(String baseViewPath) {
			return baseViewPath != null ? baseViewPath + viewPath : viewPath;
		}
	}
}









