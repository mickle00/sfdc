<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Work Time Time Out</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Agent_Work_Time__c.Start_Time__c</field>
            <operation>greaterThan</operation>
            <value>8/17/2011</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
