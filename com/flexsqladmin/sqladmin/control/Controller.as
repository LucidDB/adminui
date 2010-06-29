package com.flexsqladmin.sqladmin.control
{
	import com.adobe.cairngorm.control.FrontController;
	import com.flexsqladmin.sqladmin.commands.InitCommand;
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
    
    import com.flexsqladmin.sqladmin.events.InitEvent;
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
			addCommand(InitEvent.INITEVENT, InitCommand);
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