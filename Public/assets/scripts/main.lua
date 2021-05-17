require("BoxLib");

exit = 0;
count = 0;

function luanch()
    local flag = app.runApp("com.yk.sports")
    if  flag == true then
        toast("启动成功");
        mSleep(5000);
    else
        toast("启动失败");
    end
end

-- 查找广告按钮并点击
function findAdButtonAndClick()
    local wid= widget.desc("观看创意广告");
    if wid ~= nil then
        mSleep(1000)
        toast("控件已找到")
        mSleep(1000)
        --点击控件
        widget.click(wid)
        return true;
    else
        mSleep(1000)
        mSleep(1000)
        return false;
    end
end

-- 查找打开按钮并点击
function findOpenButtonAndClick()
    local num = getRndNum(0, 2);
    if num == 2 then
        toast("查找打开按钮")
        local result = false;
        local titles = {"打开", "Open", "開啟", "安装", "注册", "联系我们"};
        for i = 1, #titles do
            local title = titles[i];
            local wid= widget.text(title);
            if wid ~= nil then
                mSleep(1000)
                x1,y1,x2,y2 = widget.region(wid)
                toast(title.."控件已找到"); 
                mSleep(1000)
                -- dialog(tostring(x1).."-"..tostring(x2).."-"..tostring(y1).."-"..tostring(y2), 2000); 
                --点击控件
                event.tap((x2 + x1) / 2.0, (y2 + y1) / 2.0);
                mSleep(200)
                event.tap((x2 + x1) / 2.0, (y2 + y1) / 2.0);
                -- 返回
                backApp();
                result = true;
                break;
            end
        end
        if result == false then
            -- 随机点击
            toast("随机点击")
            rndClick();
            backApp();
        end
    else
        findCloseButtonAndClick();
    end
end

-- 返回app
function backApp()
    mSleep(getRndNum(3000,5000));
    local flag = app.runApp("com.yk.sports");
    if  flag == true then
        mSleep(5000);
        -- 查找关闭按钮并点击
        findCloseButtonAndClick();
    end
end

-- 查找关闭按钮并点击
function findCloseButtonAndClick()
    toast("查找关闭按钮")

    local result = false;
    local titles = {"关闭", "關閉", "Close"};
    for i = 1, #titles do
        local title = titles[i];
        local wid= widget.text(title);
        if wid ~= nil then
            mSleep(1000)
            toast(title.."控件已找到"); 
            mSleep(1000)
            --点击控件
            widget.click(wid)
            mSleep(500);
            widget.click(wid)
            -- 返回
            backApp();
            result = true;
            break;
        end
    end

    wid= widget.id("close-button-icon");
    if wid ~= nil then
        mSleep(1000)
        toast("close-button-icon"); 
        mSleep(1000)
        --点击控件
        widget.click(wid)
        -- 随机点击
        rndClick();
        result = true;
    end

    if result == false then
        toast("没有找到关闭按钮，等待")
        packageName = app.frontPackageName();
        if packageName ~= "com.yk.sports" then
            app.runApp("com.yk.sports");
            mSleep(2000);
            findCloseButtonAndClick();
        else
            local wid= widget.desc("广告赚钱");
            if wid == nil then
                exit = exit + 1;
                if exit > 4 then
                    exit = 0;
                    toast("超时，返回"); 
                    keycode.back();
                    mSleep(2000)
                else
                    mSleep(10000);
                    findCloseButtonAndClick();
                end
            end
        end
    end
end

function getCurrentPage()
    local wid= widget.desc("运动");
    if wid ~= nil then
        return "运动";
    end
    wid= widget.desc("赚钱");
    if wid ~= nil then
        return "赚钱";
    end
    wid= widget.desc("广告赚钱");
    if wid ~= nil then
        return "广告赚钱";
    end
    return nil;
end

-- 随机点击
function rndClick()
    for i=0,10,2 do
        local x = 402 + getRndNum(-300,300);
        local y = 1350 + getRndNum(0,300);
        event.tap(x, y);
        mSleep(1000);
    end
end

-- 随机点击
function sleep()
    for i=0,3,1 do
        keycode.back();
        mSleep(1000)
    end 
    local duration = getRndNum(120,240);
    for i=0,duration,2 do
        toast("休息中，剩余"..tostring(duration-i)); 
        mSleep(2000);
    end
    runtime.restart()
end

-- 屏幕常量
device.keepWake();
-- 启动App
luanch();
-- 开始循环
for i=1,99999999 do
    -- 检测应用是否打开
    packageName = app.frontPackageName();
    if packageName ~= "com.yk.sports" then
        app.runApp("com.yk.sports");
        mSleep(5000);
    end

    page = getCurrentPage();
    if page == "运动" then
        widgetFind(1,0,1,"赚钱",0,0,3000);
    elseif page == "赚钱" then
        widgetFind(1,0,1,"获取能量",0,0,3000);
    elseif page == "广告赚钱" then
        -- 查找广告按钮并点击
        result = findAdButtonAndClick();
        if result == true then
        count = count + 1;
        toast("第"..tostring(count).."次"); 
        mSleep(getRndNum(5000,1000));
        findOpenButtonAndClick();
        else
            if count >= 20 then
                sleep();
            end
        end
    else
        toast("未知页面，返回"); 
        keycode.back();
        mSleep(2000)
    end
end
