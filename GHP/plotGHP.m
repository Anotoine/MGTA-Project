% This function makes a plot of the result of applying the GHP
function plotGHP(cr)
    figure('name','Cost')
    title('Cost Function'); xlabel('Time slot (min)'); ylabel('Cost');
    hold on;
    plot(1:729,cr(:,1))
    leg(1) = cellstr(strcat('Aircraft #', num2str(1)));
    hold on;
    for i = 1:length(cr(1,:))/40
        plot(1:729,cr(:,i*40))
        leg(i+1) = cellstr(strcat('Aircraft #', num2str(i*40)));
    end
    legend(leg,'location','northwest')
    axis([0 length(cr(:,1)) 0 max(max(cr))])
    hold off;
end