package fai.plugin.ui.win;

import fai.plugin.config.Developer;
import fai.plugin.config.Options;
import fai.plugin.config.Settings;
import fai.plugin.util.ContextUtils;
import com.google.common.collect.Maps;
import com.intellij.ide.highlighter.JavaFileType;
import com.intellij.ide.util.PackageChooserDialog;
import com.intellij.openapi.editor.Document;
import com.intellij.openapi.project.Project;
import com.intellij.psi.JavaCodeFragment;
import com.intellij.psi.JavaCodeFragmentFactory;
import com.intellij.psi.PsiDocumentManager;
import com.intellij.psi.PsiPackage;
import com.intellij.ui.EditorTextField;
import org.jetbrains.annotations.NotNull;

import javax.swing.*;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import javax.swing.text.JTextComponent;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.util.Map;
import java.util.Set;
import java.util.function.Consumer;

public class FkwSetting implements IWindows {

    /**
     * 配置对象：设置信息
     */
    private final Settings settings;

    /**
     * 配置对象：是否覆盖文件
     */
    private final Options options;

    /**
     * 配置对象：开发者信息
     */
    private final Developer developer;

    /**
     * 输入框：App包名
     */
    private EditorTextField appPackageField;

    /**
     * 按钮：App 包选择
     */
    private JButton selectAppPackageButton;

    /**
     * 输入框：Cli 包名
     */
    private EditorTextField cliPackageField;

    /**
     * 按钮：Cli 包选择
     */
    private JButton selectCliPackageButton;

    /**
     * 输入框: Inf/SysInf包名
     */
    private EditorTextField infPackageField;

    /**
     * 按钮：Inf/SysInf 包选择
     */
    private JButton selectInfPackageButton;

    /**
     * 输入框: kit/SysKit 包名
     */
    private EditorTextField kitPackageField;

    /**
     * 按钮：kit/SysKit 包选择
     */
    private JButton selectKitPackageButton;

    /**
     * 输入框: svr 包名
     */
    private EditorTextField svrPackageField;

    /**
     * 按钮：Svr 包选择
     */
    private JButton selectSvrPackageButton;
    /**
     * 输入框：开发者姓名
     */
    private JTextField authorField;

    /**
     * 输入框：电子邮件
     */
    private JTextField emailField;

    /**
     * 面板：顶级页面面板
     */
    private JPanel content;

    /**
     * 复选：是否覆盖Java文件
     */
    private JCheckBox overrideJavaCheckBox;


    public FkwSetting(Settings settings, Options options, Developer developer) {
        this.settings = settings;
        this.options = options;
        this.developer = developer;

        // 初始化开发者信息的输入框内容
        initConfig();
        // 配置选择包名的按钮事件
        configSelectPackage();

        /* 普通输入框的输入事件监听 */
        class TextFieldDocumentListener implements DocumentListener {
            /**
             * 存放 setValue 与 输入框 的关系
             */
            private final Map<Consumer<String>, JTextComponent> map = Maps.newHashMap();

            public TextFieldDocumentListener() {
                map.put(developer::setAuthor, authorField);
                map.put(developer::setEmail, emailField);
            }

            @Override
            public void insertUpdate(DocumentEvent e) {
                documentChanged(e);
            }

            @Override
            public void removeUpdate(DocumentEvent e) {
                documentChanged(e);
            }

            @Override
            public void changedUpdate(DocumentEvent e) {
            }

            /**
             * swing 输入框组件内容更改事件
             *
             * @param e 事件
             */
            public void documentChanged(DocumentEvent e) {
                javax.swing.text.Document document = e.getDocument();
                Set<Map.Entry<Consumer<String>, JTextComponent>> entries = map.entrySet();
                for (Map.Entry<Consumer<String>, JTextComponent> entry : entries) {
                    if (TextFieldDocumentUtil.updateSettingValue(document, entry.getValue(), entry.getKey())) {
                        break;
                    }
                }
            }
        }

        TextFieldDocumentListener textFieldDocumentListener = new TextFieldDocumentListener();
        authorField.getDocument().addDocumentListener(textFieldDocumentListener);
        emailField.getDocument().addDocumentListener(textFieldDocumentListener);

        /* 包名输入框的输入事件监听 */
        class EditorTextFieldDocumentListener implements com.intellij.openapi.editor.event.DocumentListener {
            /**
             * 存放 setValue 与 输入框 的关系
             */
            private final Map<Consumer<String>, EditorTextField> map = Maps.newHashMap();

            public EditorTextFieldDocumentListener() {
                map.put(settings::setAppPackage, appPackageField);
                map.put(settings::setCliPackage, cliPackageField);
                map.put(settings::setInfPackage, infPackageField);
                map.put(settings::setKitPackage, kitPackageField);
                map.put(settings::setSvrPackage, svrPackageField);
            }

            /**
             * IDEA 输入框组件内容更改事件
             *
             * @param event 事件
             */
            @Override
            public void documentChanged(@NotNull com.intellij.openapi.editor.event.DocumentEvent event) {
                Document document = event.getDocument();
                Set<Map.Entry<Consumer<String>, EditorTextField>> entries = map.entrySet();
                for (Map.Entry<Consumer<String>, EditorTextField> entry : entries) {
                    if (TextFieldDocumentUtil.updateSettingValue(document, entry.getValue(), entry.getKey())) {
                        break;
                    }
                }
            }
        }

        EditorTextFieldDocumentListener editorTextFieldDocumentListener = new EditorTextFieldDocumentListener();
        appPackageField.getDocument().addDocumentListener(editorTextFieldDocumentListener);
        cliPackageField.getDocument().addDocumentListener(editorTextFieldDocumentListener);
        infPackageField.getDocument().addDocumentListener(editorTextFieldDocumentListener);
        kitPackageField.getDocument().addDocumentListener(editorTextFieldDocumentListener);
        svrPackageField.getDocument().addDocumentListener(editorTextFieldDocumentListener);

        ItemListener checkBoxItemListener = new ItemListener() {
            /**
             * 复选框勾选事件监听
             * @param e 事件
             */
            @Override
            public void itemStateChanged(ItemEvent e) {
                Object item = e.getItem();
                if (overrideJavaCheckBox == item) {
                    options.setOverrideJava(overrideJavaCheckBox.isSelected());
                }
            }
        };
        overrideJavaCheckBox.addItemListener(checkBoxItemListener);
    }

    private void createUIComponents() {
        Project project = ContextUtils.getProject();
        appPackageField = createEditorTextField(project);
        cliPackageField = createEditorTextField(project);
        infPackageField = createEditorTextField(project);
        kitPackageField = createEditorTextField(project);
        svrPackageField = createEditorTextField(project);
    }

    /**
     * 创建一个可以自动补全包名的输入框
     *
     * @param project 项目
     * @return IDEA 输入框组件
     */
    private EditorTextField createEditorTextField(Project project) {
        // https://jetbrains.org/intellij/sdk/docs/user_interface_components/editor_components.html
        JavaCodeFragment code = JavaCodeFragmentFactory.getInstance(project).createReferenceCodeFragment("", null, true, false);
        Document document = PsiDocumentManager.getInstance(project).getDocument(code);
        JavaFileType fileType = JavaFileType.INSTANCE;
        return new EditorTextField(document, project, fileType);
    }


    /**
     * 初始化开发者信息的输入框内容
     */
    private void initConfig() {
        authorField.setText(developer.getAuthor());
        emailField.setText(developer.getEmail());

        // 将前端输入的参数设置到相关的对象中
        appPackageField.setText(settings.getAppPackage());
        cliPackageField.setText(settings.getCliPackage());
        infPackageField.setText(settings.getInfPackage());
        kitPackageField.setText(settings.getKitPackage());
        svrPackageField.setText(settings.getSvrPackage());

        overrideJavaCheckBox.setSelected(options.isOverrideJava());
    }

    /**
     * 配置选择包名的按钮事件
     */
    private void configSelectPackage() {
        selectAppPackageButton.addActionListener(e -> {
            chooserPackage(appPackageField.getText(), appPackageField::setText);
        });
        selectCliPackageButton.addActionListener(e -> {
            chooserPackage(cliPackageField.getText(), cliPackageField::setText);
        });
        selectInfPackageButton.addActionListener(e -> {
            chooserPackage(infPackageField.getText(), infPackageField::setText);
        });
        selectKitPackageButton.addActionListener(e -> {
            chooserPackage(kitPackageField.getText(), kitPackageField::setText);
        });
        selectSvrPackageButton.addActionListener(e -> {
            chooserPackage(svrPackageField.getText(), svrPackageField::setText);
        });
    }

    /**
     * 选择包名
     *
     * @param defaultSelect 默认选中包名
     * @param consumer      完成事件
     */
    private void chooserPackage(String defaultSelect, Consumer<String> consumer) {
        PackageChooserDialog chooser = new PackageChooserDialog("请选择模块包", ContextUtils.getProject());
        chooser.selectPackage(defaultSelect);
        chooser.show();
        PsiPackage psiPackage = chooser.getSelectedPackage();
        if (psiPackage != null) {
            consumer.accept(psiPackage.getQualifiedName());
        }
        chooser.getDisposable().dispose();
    }

    @Override
    public JPanel getContent() {
        return content;
    }
}
