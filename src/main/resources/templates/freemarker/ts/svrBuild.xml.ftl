<?xml version="1.0"?>

<project default="${entity.name.svr}" basedir=".">

    <property name="lib" value="${r'${user.home}'}/lib" />
    <property name="mysql-jar" value="mysql-connector-java-5.1.10-bin.jar" />
    <property name="sbin" value="${r'${user.home}'}/sbin" />
    <property name="debug" value="true" />

    <target name="${entity.name.svr}">
        <property name="target" value="${entity.name.svr}" />
        <property name="src" value="." />
        <delete quiet="true">
            <fileset dir="${r'${sbin}'}/${r'${target}'}" includes="*.jar" />
        </delete>
        <copy todir="${r'${sbin}'}/${r'${target}'}" overwrite="true">
            <fileset dir="${r'${lib}'}">
                <include name="fai-comm-*.jar" />
                <include name="fai-app.jar" />
                <include name="fai-app-*.jar" />
                <include name="fai-cli.jar" />
                <include name="fai-cli-*.jar" />
                <include name="${r'${mysql-jar}'}" />
                <include name="htmlparser.jar" />
                <include name="htmllexer.jar" />
                <include name="sunjce_provider.jar" />
                <include name="jedis-2.8.2.jar" />
                <include name="fai-hdUtil.jar" />
            </fileset>
        </copy>

        <mkdir dir="${r'${src}'}/classes" />
        <path id="jar">
            <fileset dir="${r'${sbin}'}/${r'${target}'}">
            </fileset>
        </path>
        <javac classpathref="jar" srcdir="${r'${src}'}" destdir="${r'${src}'}/classes"
               debug="${r'${debug}'}">
            <include name="inf/*.java" />
            <include name="impl/*.java" />
            <include name="*.java" />
        </javac>
        <jar destfile="${r'${sbin}'}/${r'${target}'}/${r'${target}'}.jar" basedir="${r'${src}'}/classes">
            <manifest>
                <attribute name="Main-class" value="fai.svr.${r'${target}'}.${r'${target}'}" />
            </manifest>
        </jar>
        <delete includeEmptyDirs="true">
            <fileset dir="${r'${src}'}/classes" />
        </delete>
    </target>

</project>
