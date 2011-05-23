/*
Dynamo Admin UI is a web service project for administering LucidDB
Copyright (C) 2010 Dynamo Business Intelligence Corporation

This program is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your option)
any later version approved by Dynamo Business Intelligence Corporation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*/
package com.dynamobi.adminui.control
{
	import com.adobe.cairngorm.control.FrontController;
	import com.dynamobi.adminui.commands.*;
	import com.dynamobi.adminui.events.*;
	
	public class Controller extends FrontController
	{
        private static var self:Controller;

        public static function getInstance():Controller
        {
            if (self == null)
                self = new Controller();
            return self;
        }
        
		public function Controller()
		{
            if (self == null)
                self = this;
			addCommand(LoginEvent.LOGIN, LoginCommand);
			addCommand(MetaDataEvent.METADATA, MetaDataCommand);
			addCommand(ExecuteSQLEvent.EXECUTESQL, ExecuteSQLCommand);
			addCommand(OpenTableEvent.OPENTABLE, OpenTableCommand);
			addCommand(TableMetaDataEvent.TABLEMETADATA, TableMetaDataCommand);
			addCommand(DeleteRowEvent.DELETEROW, DeleteRowCommand);
			addCommand(UpdateDataEvent.UPDATEDATA, UpdateDataCommand);
			addCommand(InsertRowEvent.INSERTROW, InsertRowCommand);
			addCommand(ListCatalogsEvent.LISTCATALOGS, ListCatalogsCommand);
            addCommand(TableDetailsEvent.TABLEDETAILS, TableDetailsCommand);
            addCommand(UsersAndRolesEvent.USERSANDROLES, UsersAndRolesCommand);
            addCommand(ObjectTreeLoaderEvent.OBJECT_TREE_LOADER, ObjectTreeLoaderCommand);
            addCommand(PerformanceEvent.PERFORMANCE, PerformanceCommand);
		}
        
	}
}