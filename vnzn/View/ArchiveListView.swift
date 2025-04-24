import SwiftUI

struct ArchiveListView: View {

    @Environment(Router.self) var router: Router
    var metaData: MetaData

    var body: some View {
        List {
            ForEach(metaData.archive.years, id: \.self) { year in
                Text(year.name)
                    .bold()
                ForEach(year.months, id: \.self) { month in
                    Button {
                        router.currentNavigationPath.append(NavigationTarget.archiveMonth(month))
                    } label: {
                        HStack {
                            Text(month.monthName)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
