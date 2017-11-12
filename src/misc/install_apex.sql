-- see http://joelkallman.blogspot.de/2017/05/apex-and-ords-up-and-running-in2-steps.html

define TBLS_APEX      = &1
define TBLS_FILES     = &2
define TBLS_TEMP      = &3
define IMG_DIR        = &3



-- Install APEX
@apexins &TBLS_APEX &TBLS_FILES &TBLS_TEMP &IMG_DIR

-- Unlock the APEX_PUBLIC_USER account
alter user apex_public_user identified by apex account unlock;

-- Create the APEX Instance Administration user
begin
    apex_util.set_security_group_id( 10 );
    apex_util.create_user(
        p_user_name => 'ADMIN',
        p_email_address => 'admin@dev.loc',
        p_web_password => 'admin',
        p_developer_privs => 'ADMIN' );
    apex_util.create_user(
        p_user_name => 'TEST',
        p_email_address => 'test@dev.loc.de',
        p_web_password => 'test',
        p_developer_privs => 'ADMIN' );
    apex_util.create_user(
        p_user_name => 'CMU',
        p_email_address => 'cmu@dev.loc.de',
        p_web_password => 'cmu',
        p_developer_privs => 'ADMIN' );
    apex_util.set_security_group_id( null );
    commit;
end;
/

-- Run APEX REST configuration
@apex_rest_config_core.sql apex apex

-- Create a network ACE for APEX
declare
    l_acl_path varchar2(4000);
    l_apex_schema varchar2(100);
begin
    for c1 in (select schema
                 from sys.dba_registry
                where comp_id = 'APEX') loop
        l_apex_schema := c1.schema;
    end loop;
    sys.dbms_network_acl_admin.append_host_ace(
        host => '*',
        ace => xs$ace_type(privilege_list => xs$name_list('connect'),
        principal_name => l_apex_schema,
        principal_type => xs_acl.ptype_db));
    commit;
end;
/
