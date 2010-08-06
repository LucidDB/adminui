/*
Copyright 2006-2010 Kevin Kazmierczak. All rights reserved.
Copyright 2010 Dynamo Business Intelligence Corporation. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY Dynamo Business Intelligence Corporation ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Dynamo Business Intelligence Corporation OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package com.flexsqladmin.sqladmin.control
{
	import com.adobe.cairngorm.control.FrontController;
    import com.flexsqladmin.sqladmin.commands.LoginCommand;
    import com.flexsqladmin.sqladmin.commands.MetaDataCommand;
    import com.flexsqladmin.sqladmin.commands.ExecuteSQLCommand;
    import com.flexsqladmin.sqladmin.commands.OpenTableCommand;
    import com.flexsqladmin.sqladmin.commands.TableMetaDataCommand;
    import com.flexsqladmin.sqladmin.commands.DeleteRowCommand;
    import com.flexsqladmin.sqladmin.commands.UpdateDataCommand;
    import com.flexsqladmin.sqladmin.commands.InsertRowCommand;
    import com.flexsqladmin.sqladmin.commands.ListCatalogsCommand;
    import com.flexsqladmin.sqladmin.commands.TableDetailsCommand;
    import com.flexsqladmin.sqladmin.commands.UsersAndRolesCommand;
    
    import com.flexsqladmin.sqladmin.events.LoginEvent;
    import com.flexsqladmin.sqladmin.events.MetaDataEvent;
    import com.flexsqladmin.sqladmin.events.ExecuteSQLEvent;
    import com.flexsqladmin.sqladmin.events.OpenTableEvent;
    import com.flexsqladmin.sqladmin.events.TableMetaDataEvent;
    import com.flexsqladmin.sqladmin.events.DeleteRowEvent;
	import com.flexsqladmin.sqladmin.events.UpdateDataEvent;
	import com.flexsqladmin.sqladmin.events.InsertRowEvent;
	import com.flexsqladmin.sqladmin.events.ListCatalogsEvent;
    import com.flexsqladmin.sqladmin.events.TableDetailsEvent;
    import com.flexsqladmin.sqladmin.events.UsersAndRolesEvent;
	
	public class Controller extends FrontController
	{
		public function Controller()
		{
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
		}
	}
}