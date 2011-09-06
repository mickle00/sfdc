<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>WorkIt2__WorkIt_Case_Overtime_Level_Green</fullName>
        <field>WorkIt2__Color__c</field>
        <literalValue>Green</literalValue>
        <name>WorkIt! Case Overtime Level: Green</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WorkIt2__WorkIt_Case_Overtime_Level_Red</fullName>
        <field>WorkIt2__Color__c</field>
        <literalValue>Red</literalValue>
        <name>WorkIt! Case Overtime Level: Red</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WorkIt2__WorkIt_Case_Overtime_Level_Yellow</fullName>
        <field>WorkIt2__Color__c</field>
        <literalValue>Yellow</literalValue>
        <name>WorkIt! Case Overtime Level: Yellow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WorkIt2__WorkIt_Set_Case_Allow_Update_to_On</fullName>
        <field>WorkIt2__Allow_Update__c</field>
        <literalValue>1</literalValue>
        <name>WorkIt! Set Case &quot;Allow Update&quot; to On</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WorkIt2__WorkIt_Set_Closed_with_Package_to_On</fullName>
        <field>WorkIt2__Closed_with_Package__c</field>
        <literalValue>1</literalValue>
        <name>WorkIt! Set &quot;Closed with Package&quot; to On</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WorkIt2__WorkIt_Set_Don_t_Time_to_Off</fullName>
        <field>WorkIt2__Dont_Time__c</field>
        <literalValue>0</literalValue>
        <name>WorkIt! Set &quot;Don&apos;t Time&quot; to Off</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WorkIt2__WorkIt_Set_Don_t_Time_to_On</fullName>
        <field>WorkIt2__Dont_Time__c</field>
        <literalValue>1</literalValue>
        <name>WorkIt! Set &quot;Don&apos;t Time&quot; to On</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WorkIt2__WorkIt%21 Case Close</fullName>
        <actions>
            <name>WorkIt2__WorkIt_Set_Closed_with_Package_to_On</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WorkIt2__WorkIt_Set_Don_t_Time_to_On</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Makes WorkIt! stop timing a case when it&apos;s closed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WorkIt2__WorkIt%21 Case Open</fullName>
        <actions>
            <name>WorkIt2__WorkIt_Set_Don_t_Time_to_Off</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Makes WorkIt! start timing a case when it&apos;s opened.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
